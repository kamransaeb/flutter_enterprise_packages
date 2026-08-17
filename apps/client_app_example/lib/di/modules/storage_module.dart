import 'package:client_app_example/core/constants/di_constants.dart';
import 'package:client_app_example/core/constants/storage_constants.dart';
import 'package:enterprise_logger/enterprise_logger.dart';
import 'package:enterprise_storage/enterprise_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Storage module for local storage
@module
abstract class StorageModule {
  // ===========================================================================
  // SharedPreferences
  // ===========================================================================

  /// Shared preferences storage for local storage
  // await dependencies to be resolved before DI setup continues.
  // getInstance() is async, so we need to await it.
  @preResolve
  Future<SharedPreferences> get sharedPrefrences =>
      SharedPreferences.getInstance();

  /// Shared preferences storage for local storage
  @singleton
  // @Named: choose between multiple bindings of the same type.
  // you register the same type multiple times with different names.
  @Named(DiConstants.sharedPrefs)
  LocalStorage sharedPrefsStorage(
    SharedPreferences prefs,
    LoggerService logger,
  ) => SharedPrefsStorage(prefs, logger);

  // ===========================================================================
  // Secure storage
  // ===========================================================================
/// Shared preferences storage for local storage
  @singleton
  FlutterSecureStorage get flutterSecureStorage => const FlutterSecureStorage(
    // aOptions: AndroidOptions(),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
  );

/// Secure storage for local storage
  @singleton
  @Named(DiConstants.secureStorage)
  LocalStorage secureStorage(
    FlutterSecureStorage storage,
    LoggerService logger,
  ) => SecureStorage(storage, logger);

  // ===========================================================================
  // Hive
  // ===========================================================================

  /// Hive storage for local storage
  @singleton
  @Named(DiConstants.hiveStorage)
  LocalStorage hiveStorage(LoggerService logger) => HiveStorage(
    logger,
    defaultBoxes: const [
      StorageConstants.settingsBox,
      StorageConstants.cacheBox,
      StorageConstants.userBox,
    ],
    // registerAdapters: [
    //   UserAdapter(),
    //   SettingsAdapter(),
    //   CacheAdapter(),
    // ],
  );

  /// Concrete type for Hive-only APIs (watchBox, writeJson, …).
  /// Same instance as `@Named(DiConstants.hiveStorage)` after initializer runs.
  @singleton
  HiveStorage hiveStorageConcrete(
    @Named(DiConstants.hiveStorage) LocalStorage storage,
  ) => storage as HiveStorage;
}
