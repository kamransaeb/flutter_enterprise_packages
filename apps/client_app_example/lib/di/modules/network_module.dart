import 'package:client_app_example/di/injection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
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

  /// Provides [DioClient] for making HTTP requests.
  @lazySingleton
  DioClient dioClient(
    NetworkClientConfig config,
    LoggerService logger,
    DeviceNetworkInfo deviceInfo,
  ) {
    final retry = RetryInterceptor(logger);

    final client = DioClient(
      config,
      logger,
      // Interceptors in order:
      // 1. HeaderInterceptor
      // 2. AuthInterceptor
      // 3. LoggingInterceptor
      // 4. RetryInterceptor
      // 5. ErrorInterceptor
      interceptors: [
        HeaderInterceptor(
          deviceInfo,
          () => {
            // 'App-Version': '...', from package_info in app later
            // 'Build-Number': '1',
            // 'X-Environment': 'dev', // only in debug
            'Accept-Language': 'en',
          },
        ),
        AuthInterceptor(
          logger,
          () async {
            return getIt<LocalStorage>(
              instanceName: 'secure_storage',
            ).read<String>('access_token');
          },
          () async {
            // Dio call with Options(extra: {'isRefreshCall': true, 'skipAuth':
            // true})
            // save tokens, return new access token
            return null;
          },
          () async {
            // clear tokens, navigate to login
            return null;
          },
        ),
        if (config.enableLogging)
          LoggingInterceptor(
            logger,
          ),
        retry,
        ErrorInterceptor(logger),
      ],
    );
    return client;
  }
}
