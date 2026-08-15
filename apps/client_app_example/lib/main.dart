import 'dart:async';

import 'package:client_app_example/bootstrap/initialize_app_services.dart';
import 'package:client_app_example/di/injection.dart';
import 'package:client_app_example/errors/error_mapper.dart';
import 'package:client_app_example/features/posts/domain/usecases/get_post_usecase.dart';
import 'package:client_app_example/features/posts/presentation/pages/posts_demo_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:enterprise_core/enterprise_core.dart';
import 'package:enterprise_storage/enterprise_storage.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  // ensure the binding is initialized before anything else.
  WidgetsFlutterBinding.ensureInitialized();

  // ensure the easy localization is initialized.
  await EasyLocalization.ensureInitialized();

  // initialize the dependencies.
  await configureDependencies();

  // initialize the storage.
  await initializeAppServices();

  // run the app.
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('tr')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const ClientAppExample(),
    ),
  );
}

/// The main app widget.
class ClientAppExample extends StatelessWidget {
  /// Creates a [ClientAppExample] widget.
  const ClientAppExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Client App Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: const PostsDemoPage(),
      //home: const StorageDemoPage(),
    );
  }
}

/// A demo page that shows how to use the storage.
class StorageDemoPage extends StatefulWidget {
  /// Creates a [StorageDemoPage] widget.
  const StorageDemoPage({super.key});

  @override
  State<StorageDemoPage> createState() => _StorageDemoPageState();
}

class _StorageDemoPageState extends State<StorageDemoPage> {
  int _counter = 0;
  LocalStorage get _prefs => getIt<LocalStorage>(instanceName: 'shared_prefs');
  String? _httpStatus;
  String? _lastTitle;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load() async {
    final value = await _prefs.read<int>('demo_counter') ?? 0;
    if (!mounted) return;
    setState(() {
      _counter = value;
    });
  }

  Future<void> _increment() async {
    final next = _counter + 1;
    await _prefs.write('demo_counter', next);
    await getIt<LocalStorage>(
      instanceName: 'hive_storage',
    ).write('last_counter', next, boxName: 'settings_box');
    setState(() => _counter = next);
  }

  void _showErrorMessage() {
    final failure = getIt<ErrorHandler>().handleError(
      Exception('demo boom'),
      reason: 'sorage demo',
    );
    final message = ErrorMapper.toUserMessage(failure);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _demoGet({bool forceRefresh = false}) async {
    try {
      //final sw = Stopwatch()..start();

      // final response = await getIt<DioClient>().get<dynamic>(
      //   '/posts/1',
      //   options: Options(
      //     extra: {
      //       NetworkConstants.skipAuthExtraKey: true,
      //       if (forceRefresh) NetworkConstants.forceRefreshExtraKey: true,
      //     },
      //   ), // public endpoint
      // );
      // final result = await getIt<PostsRepository>().getPost(
      //   1,
      //   forceRefresh: forceRefresh,
      // );

      final result = await getIt<GetPostUseCase>().call(
        GetPostParams(id: 1, forceRefresh: forceRefresh),
      );

      // With failures no try/catch is needed, Failures are already Left<Failure>.
      return result.fold(
        (failure) {
          final message = ErrorMapper.toUserMessage(failure);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
        },
        (post) {
          if (!mounted) return;
          setState(() {
            _httpStatus = '200';
            _lastTitle = post.title;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'GET /posts/1 → $_httpStatus - $_lastTitle',
              ),
            ),
          );
        },
      );

      // final fromCache =
      //     response.extra[NetworkConstants.cacheResponseExtraKey] == true;
      // final isFallback =
      //     response.extra[NetworkConstants.isFallbackExtraKey] == true;

      // final post = ResponseParser.parseData(
      //   response,
      //   (json) => json as Map<String, dynamic>,
      // );

      // if (!mounted) return;
      // setState(() {
      //   _httpStatus = '${response.statusCode}';
      //   _lastTitle = post['title']?.toString();
      // });

      // final source = isFallback
      //     ? 'fallback cache'
      //     : fromCache && sw.elapsedMilliseconds < 100
      //     ? 'memory cache'
      //     : 'network';

      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text(
      //       'GET /posts/1 → ${response.statusCode} ($source, ${sw.elapsedMilliseconds}ms)',
      //     ),
      //   ),
      // );
    } on Object catch (e) {
      final failure = getIt<ErrorHandler>().handleError(e, reason: 'demo GET');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ErrorMapper.toUserMessage(failure))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            Text(
              'Prefs counter:$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            Text(
              'Last GET status: ${_httpStatus ?? '—'}'
              '\nLast title: ${_lastTitle ?? '—'}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _increment,
            child: const Icon(Icons.add),
          ),
          FloatingActionButton(
            heroTag: 'demoGet',
            onPressed: _demoGet,
            child: const Icon(Icons.get_app),
          ),
          FloatingActionButton(
            heroTag: 'demoGetForceRefresh',
            onPressed: () => _demoGet(forceRefresh: true),
            child: const Icon(Icons.refresh),
          ),
          FloatingActionButton(
            onPressed: _showErrorMessage,
            child: const Icon(Icons.bug_report),
          ),
        ],
      ),
    );
  }
}
