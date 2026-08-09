import 'package:dio/dio.dart';
import 'package:enterprise_logger/enterprise_logger.dart';

/// Dio interceptor that logs requests/responses via [LoggerService].
///
/// Safe defaults for production: redacts auth headers and can skip bodies.
class LoggingInterceptor extends Interceptor {
  /// Constructor for the LoggingInterceptor class
  LoggingInterceptor(
    this._logger, {
    this.logBodies = false,
    this.maxBodyLength = 1024,
    this.sensitiveHeaderKeys = const {'Authorization', 'X-API-Key'},
  });

  final LoggerService _logger;

  /// Whether to log the bodies of requests/responses
  final bool logBodies;

  /// The maximum length of the body to log
  final int maxBodyLength;

  /// The headers to redact from the logs
  final Set<String> sensitiveHeaderKeys;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _logger.d(
      '[HTTP] → ${options.method} ${options.uri}\n'
      'Headers: ${_redactHeaders(options.headers)}\n'
      'Query: ${options.queryParameters}\n'
      'Body: ${_formatBody(options.data)}',
    );
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
   _logger.d(
      '[HTTP] ← ${response.statusCode} ${response.requestOptions.method} '
      '${response.requestOptions.uri}\n'
      'Body: ${_formatBody(response.data)}',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logger.e(
      '[HTTP] ✗ ${err.requestOptions.method} ${err.requestOptions.uri}\n'
      'Type: ${err.type}\n'
      'Status: ${err.response?.statusCode}\n'
      'Message: ${err.message}\n'
      'Body: ${_formatBody(err.response?.data)}',
      error: err,
      stackTrace: err.stackTrace,
    );
    handler.next(err);
  }

  Map<String, dynamic> _redactHeaders(Map<String, dynamic> headers) {
    return {
      for (final entry in headers.entries)
        entry.key: sensitiveHeaderKeys.contains(entry.key.toLowerCase())
            ? '***'
            : entry.value,
    };
  }

  String _formatBody(Object? data) {
    if (!logBodies) return '<omitted>';
    if (data == null) return 'null';
    final text = data.toString();
    if (text.length <= maxBodyLength) return text;
    return '${text.substring(0, maxBodyLength)}… (${text.length} chars)';
  }
}
