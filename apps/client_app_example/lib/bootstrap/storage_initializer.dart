import 'package:client_app_example/di/injection.dart';
import 'package:enterprise_storage/enterprise_storage.dart';

Future<void> initializeStorage() async {
  final prefs = getIt<LocalStorage>(instanceName: 'shared_prefs');
  final secureStorage = getIt<LocalStorage>(instanceName: 'secure_storage');
  final hiveStorage = getIt<LocalStorage>(instanceName: 'hive_storage');
  
  await prefs.initialize();
  await secureStorage.initialize();
  await hiveStorage.initialize();
}