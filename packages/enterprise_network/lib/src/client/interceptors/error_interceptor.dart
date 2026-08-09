import 'package:dio/dio.dart';
import 'package:enterprise_core/enterprise_core.dart';
import 'package:enterprise_logger/enterprise_logger.dart';

/// Maps [DioException] into typed [NetworkException]s (on `error.error`)
/// and forwards the chain.
///
/// Place **after** RetryInterceptor so retries see the original error first.
class ErrorInterceptor extends Interceptor {
  /// Creates an [ErrorInterceptor].
  ErrorInterceptor(this._logger);

  final LoggerService _logger;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final transformed = _transformException(err);
    _logger.e(
      'HTTP error: ${err.requestOptions.method} ${err.requestOptions.uri}',
      error: transformed.error ?? transformed,
      stackTrace: err.stackTrace,
    );

    // Prefer next over reject so other interceptors / callers still see
    // DioException.
    return handler.next(transformed);
  }

  DioException _transformException(DioException err) {
    final path = err.requestOptions.path;
    final method = err.requestOptions.method;
    final response = err.response;

    final NetworkException appError;

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
        appError = ConnectionTimeoutException(
          endpoint: path,
          method: method,
          timeoutDuration: err.requestOptions.connectTimeout,
        );
      case DioExceptionType.sendTimeout:
        appError = SendTimeoutException(
          endpoint: path,
          method: method,
          timeoutDuration: err.requestOptions.sendTimeout,
        );
      case DioExceptionType.receiveTimeout:
        appError = ReceiveTimeoutException(
          endpoint: path,
          method: method,
          timeoutDuration: err.requestOptions.receiveTimeout,
        );
      case DioExceptionType.connectionError:
        appError = NoInternetConnectionException(
          endpoint: path,
          method: method,
        );

      case DioExceptionType.cancel:
        appError = RequestCancelledException(
          endpoint: path,
          method: method,
        );

      case DioExceptionType.badCertificate:
        appError = SslException(
          message: 'Security certificate error',
          endpoint: path,
          method: method,
        );

      case DioExceptionType.badResponse:
        appError = HttpStatusException(
          message:
              _messageFromResponse(response) ??
              'HTTP ${response?.statusCode ?? 'error occured.'}',
          statusCode: response?.statusCode ?? 0,
          endpoint: path,
          method: method,
          responseData: response?.data,
        );

      case DioExceptionType.transformTimeout:
        appError = ConnectionTimeoutException(
          message: 'Transform timeout',
          endpoint: path,
          method: method,
        );

      case DioExceptionType.unknown:
        appError = NetworkException(
          message: err.message ?? 'Unknown network error',
          endpoint: path,
          method: method,
        );
    }

    return DioException(
      requestOptions: err.requestOptions,
      response: response,
      type: err.type,
      error: appError,
      stackTrace: err.stackTrace,
      message: appError.message,
    );
  }

  /// Best-effort extract of API error message from common JSON shapes.
  String? _messageFromResponse(Response<dynamic>? response) {
    final data = response?.data;
    if (data is Map) {
      final message = data['message'] ?? data['error'] ?? data['detail'];
      if (message is String && message.isNotEmpty) return message;
    }
    if (data is String && data.isNotEmpty) return data;
    return response?.statusMessage;
  }
}
