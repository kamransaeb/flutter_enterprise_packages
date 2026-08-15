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
  @Named('shared_prefs')
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
  @Named('secure_storage')
  LocalStorage secureStorage(
    FlutterSecureStorage storage,
    LoggerService logger,
  ) => SecureStorage(storage, logger);

  // ===========================================================================
  // Hive
  // ===========================================================================

  /// Hive storage for local storage
  @singleton
  @Named('hive_storage')
  LocalStorage hiveStorage(LoggerService logger) => HiveStorage(
    logger,
    defaultBoxes: const ['settings_box', 'cache_box', 'user_box'],
    // registerAdapters: [
    //   UserAdapter(),
    //   SettingsAdapter(),
    //   CacheAdapter(),
    // ],
  );

  /// Concrete type for Hive-only APIs (watchBox, writeJson, …).
  /// Same instance as @Named('hive_storage') after initializer runs.
  @singleton
  HiveStorage hiveStorageConcrete(
    @Named('hive_storage') LocalStorage storage,
  ) => storage as HiveStorage;
}
