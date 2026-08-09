import 'package:dio/dio.dart';
import 'package:enterprise_logger/enterprise_logger.dart';
import 'package:enterprise_network/src/client/interceptors/auth_interceptor.dart';
import 'package:enterprise_network/src/client/interceptors/retry_interceptor.dart';
import 'package:enterprise_network/src/client/network_client_config.dart';

/// Dio client for the network client
class DioClient {
  /// Constructor for the DioClient class
  DioClient(
    this._config,
    this._logger, {
    this.interceptors = const [],
  }) {
    _dio = Dio(
      BaseOptions(
        baseUrl: _config.baseUrl,
        connectTimeout: _config.connectTimeout,
        receiveTimeout: _config.receiveTimeout,
        sendTimeout: _config.sendTimeout,
        headers: _config.defaultHeaders,
        validateStatus: (status) =>
            status != null && status < _config.validateStatusBelow,
      ),
    );
    if (interceptors.isNotEmpty) {
      for (final interceptor in interceptors) {
        if (interceptor is RetryInterceptor) {
          interceptor.dio = _dio;
        }
        if (interceptor is AuthInterceptor) {
          interceptor.dio = _dio;
        }
      }
      _dio.interceptors.addAll(interceptors);
    }
  }

  final NetworkClientConfig _config;
  final LoggerService _logger;

  /// Interceptors to be used by the Dio client
  final List<Interceptor> interceptors;
  late final Dio _dio;

  /// Returns the Dio client
  Dio get dio => _dio;

  /// Returns the network client config
  NetworkClientConfig get config => _config;

  /// Performs a GET request to the given path
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
    } on Object catch (e, stackTrace) {
      _logger.e(
        'GET failed: $path',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Performs a POST request to the given path
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on Object catch (e, stackTrace) {
      _logger.e(
        'POST failed: $path',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Performs a PUT request to the given path
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on Object catch (e, stackTrace) {
      _logger.e(
        'PUT failed: $path',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Performs a DELETE request to the given path
  Future<Response<T>> delete<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on Object catch (e, stackTrace) {
      _logger.e(
        'DELETE failed: $path',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Performs a PATCH request to the given path
  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on Object catch (e, stackTrace) {
      _logger.e(
        'PATCH failed: $path',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Performs a HEAD request to the given path
  Future<Response<T>> head<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.head<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on Object catch (e, stackTrace) {
      _logger.e(
        'HEAD failed: $path',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}
