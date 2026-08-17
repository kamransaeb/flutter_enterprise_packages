import 'package:client_app_example/core/constants/di_constants.dart';
import 'package:client_app_example/di/injection.dart';
import 'package:enterprise_network/enterprise_network.dart';
import 'package:enterprise_storage/enterprise_storage.dart';

/// Initializes the app services.
Future<void> initializeAppServices() async {
  final prefs = getIt<LocalStorage>(instanceName: DiConstants.sharedPrefs);
  final secureStorage = getIt<LocalStorage>(
    instanceName: DiConstants.secureStorage,
  );
  final hiveStorage = getIt<LocalStorage>(
    instanceName: DiConstants.hiveStorage,
  );

  await getIt<DeviceNetworkInfo>().initialize();
  
  await prefs.initialize();
  await secureStorage.initialize();
  await hiveStorage.initialize();
}
