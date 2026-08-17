import 'package:client_app_example/core/constants/di_constants.dart';
import 'package:client_app_example/core/constants/storage_constants.dart';
import 'package:client_app_example/network/hive_network_cache_store.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:enterprise_logger/enterprise_logger.dart';
import 'package:enterprise_network/enterprise_network.dart';
import 'package:enterprise_storage/enterprise_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

/// Injectable bindings for network utilities and helpers.
@module
abstract class NetworkModule {
  /// Provides [Connectivity] for link-state checks.
  @lazySingleton
  Connectivity get connectivity => Connectivity();

  /// Provides [InternetConnection] for reachability checks.
  @lazySingleton
  InternetConnection get internetConnection => InternetConnection();

  /// Provides [DeviceInfoPlugin] for platform device metadata.
  @lazySingleton
  DeviceInfoPlugin get deviceInfoPlugin => DeviceInfoPlugin();

  /// Provides [NetworkHelper] for connectivity and online checks.
  @lazySingleton
  NetworkHelper networkHelper(
    Connectivity connectivity,
    InternetConnection internetConnection,
    LoggerService logger,
  ) => NetworkHelper(
    logger,
    connectivity: connectivity,
    internetConnection: internetConnection,
  );

  /// Provides [JsonTransformer] for request/response JSON mapping.
  @lazySingleton
  JsonTransformer jsonTransformer(LoggerService logger) =>
      JsonTransformer(logger);

  /// Provides [DeviceNetworkInfo] backed by [DeviceInfoPlugin].
  @lazySingleton
  DeviceNetworkInfo deviceNetworkInfo(DeviceInfoPlugin plugin) =>
      DeviceNetworkInfo(plugin: plugin);

  /// App-owned HTTP config (no AppConfig in packages).
  @lazySingleton
  NetworkClientConfig get networkClientConfig => const NetworkClientConfig(
    baseUrl: 'https://jsonplaceholder.typicode.com',
  );

  /// Provides [NetworkCacheStore] backed by [HiveNetworkCacheStore] for 
  /// caching network requests.
  @lazySingleton
  NetworkCacheStore networkCacheStore(
    @Named(DiConstants.hiveStorage) LocalStorage hiveStorage,
  ) => HiveNetworkCacheStore(hiveStorage);

  /// Provides [Dio] for making HTTP requests.
  @lazySingleton
  Dio dio(DioClient client) => client.dio;

  /// Provides [DioClient] for making HTTP requests.
  @lazySingleton
  DioClient dioClient(
    NetworkClientConfig config,
    LoggerService logger,
    DeviceNetworkInfo deviceInfo,
    @Named(DiConstants.secureStorage) LocalStorage secureStorage,
    NetworkCacheStore cacheStore, 
  ) {
    final client = DioClient(
      config,
      logger,
      // Interceptors in order:
      // 1. HeaderInterceptor
      // 2. AuthInterceptor
      // 3. CacheInterceptor
      // 4. LoggingInterceptor
      // 5. RetryInterceptor
      // 6. ErrorInterceptor
      interceptors: [
        HeaderInterceptor(
          deviceInfo,
          () => {
            // 'App-Version': '...', from package_info in app later
            // 'Build-Number': '1',
            // 'X-Environment': 'dev', // only in debug
            NetworkConstants.acceptLanguage: 'en',
          },
        ),
        AuthInterceptor(
          logger,
          () => secureStorage.read<String>(StorageConstants.accessToken),
          () async {
            // Dio call with Options(extra: {
            //   NetworkConstants.isRefreshCallExtraKey: true,
            //   NetworkConstants.skipAuthExtraKey: true,
            // })
            // save tokens, return new access token
            return null;
          },
          () async {
            await secureStorage.delete(StorageConstants.accessToken);
            await secureStorage.delete(StorageConstants.refreshToken);
          },
        ),
        CacheInterceptor(logger, cacheStore),
        if (config.enableLogging)
          LoggingInterceptor(
            logger,
          ),
        RetryInterceptor(logger),
        ErrorInterceptor(logger),
      ],
    );
    return client;
  }
}
