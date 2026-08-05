import 'package:client_app_example/bootstrap/storage_initializer.dart';
import 'package:client_app_example/di/injection.dart';
import 'package:enterprise_storage/enterprise_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Future<void> main() async {
  // ensure the binding is initialized before anything else.
  WidgetsFlutterBinding.ensureInitialized();

  // initialize the dependencies.
  await configureDependencies();

  // initialize the storage.
  await initializeStorage();

  // run the app.
  runApp(const ClientAppExample());
}

class ClientAppExample extends StatelessWidget {
  const ClientAppExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Client App Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const StorageDemoPage(),
    );
  }
}

class StorageDemoPage extends StatefulWidget {
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
    _load();
  }

  Future<void> _load() async {
    final value = await _prefs.read<int>('demo_counter') ?? 0;
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
      floatingActionButton: FloatingActionButton(
        onPressed: _increment,
        child: const Icon(Icons.add),
      ),
    );
  }
}
