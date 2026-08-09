import 'dart:async';

import 'package:client_app_example/bootstrap/initialize_app_services.dart';
import 'package:client_app_example/di/injection.dart';
import 'package:client_app_example/errors/error_mapper.dart';
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
      home: const StorageDemoPage(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text(
          'Prefs counter:$_counter',
          style: Theme.of(context).textTheme.headlineMedium,
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
            onPressed: _showErrorMessage,
            child: const Icon(Icons.bug_report),
          ),
        ],
      ),
    );
  }
}
