// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:device_info_plus/device_info_plus.dart' as _i833;
import 'package:enterprise_core/enterprise_core.dart' as _i89;
import 'package:enterprise_logger/enterprise_logger.dart' as _i194;
import 'package:enterprise_network/enterprise_network.dart' as _i496;
import 'package:enterprise_storage/enterprise_storage.dart' as _i42;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart'
    as _i161;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../errors/app_error_reporter.dart' as _i589;
import 'modules/core_module.dart' as _i134;
import 'modules/logger_module.dart' as _i205;
import 'modules/network_module.dart' as _i851;
import 'modules/storage_module.dart' as _i148;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final storageModule = _$StorageModule();
    final loggerModule = _$LoggerModule();
    final networkModule = _$NetworkModule();
    final coreModule = _$CoreModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => storageModule.sharedPrefrences,
      preResolve: true,
    );
    gh.singleton<_i194.LoggerConfig>(() => loggerModule.loggerConfig());
    gh.singleton<_i558.FlutterSecureStorage>(
      () => storageModule.flutterSecureStorage,
    );
    gh.lazySingleton<_i895.Connectivity>(() => networkModule.connectivity);
    gh.lazySingleton<_i161.InternetConnection>(
      () => networkModule.internetConnection,
    );
    gh.lazySingleton<_i833.DeviceInfoPlugin>(
      () => networkModule.deviceInfoPlugin,
    );
    gh.lazySingleton<_i496.DeviceNetworkInfo>(
      () => networkModule.deviceNetworkInfo(gh<_i833.DeviceInfoPlugin>()),
    );
    gh.singleton<_i194.LoggerService>(
      () => loggerModule.loggerService(gh<_i194.LoggerConfig>()),
    );
    gh.singleton<_i42.LocalStorage>(
      () => storageModule.hiveStorage(gh<_i194.LoggerService>()),
      instanceName: 'hive_storage',
    );
    gh.singleton<_i42.HiveStorage>(
      () => storageModule.hiveStorageConcrete(
        gh<_i42.LocalStorage>(instanceName: 'hive_storage'),
      ),
    );
    gh.singleton<_i42.LocalStorage>(
      () => storageModule.sharedPrefsStorage(
        gh<_i460.SharedPreferences>(),
        gh<_i194.LoggerService>(),
      ),
      instanceName: 'shared_prefs',
    );
    gh.lazySingleton<_i496.NetworkHelper>(
      () => networkModule.networkHelper(
        gh<_i895.Connectivity>(),
        gh<_i161.InternetConnection>(),
        gh<_i194.LoggerService>(),
      ),
    );
    gh.singleton<_i42.LocalStorage>(
      () => storageModule.secureStorage(
        gh<_i558.FlutterSecureStorage>(),
        gh<_i194.LoggerService>(),
      ),
      instanceName: 'secure_storage',
    );
    gh.singleton<_i589.AppErrorReporter>(
      () => coreModule.appErrorReporter(gh<_i194.LoggerService>()),
    );
    gh.lazySingleton<_i496.JsonTransformer>(
      () => networkModule.jsonTransformer(gh<_i194.LoggerService>()),
    );
    gh.singleton<_i89.ErrorHandler>(
      () => coreModule.errorHandler(
        gh<_i194.LoggerService>(),
        gh<_i589.AppErrorReporter>(),
      ),
    );
    return this;
  }
}

class _$StorageModule extends _i148.StorageModule {}

class _$LoggerModule extends _i205.LoggerModule {}

class _$NetworkModule extends _i851.NetworkModule {}

class _$CoreModule extends _i134.CoreModule {}
