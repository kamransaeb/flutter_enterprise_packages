import 'package:dio/dio.dart';
import 'package:enterprise_logger/enterprise_logger.dart';

/// Retries transient failures with exponential backoff.
///
/// Must receive the **same** [Dio] instance used for the request
/// (set via [dio] after construction, or pass in constructor once Dio exists).
class RetryInterceptor extends Interceptor {
  /// Constructor for the RetryInterceptor class
  RetryInterceptor(
    this._logger, {
    this.dio,
    this.maxRetries = 3,
    this.baseDelay = const Duration(milliseconds: 500),
    this.retryStatusCodes = const {408, 429, 500, 502, 503, 504},
    this.retryMethods = const {'GET', 'HEAD', 'OPTIONS'},
    this.retryCountExtraKey = 'retryCount',
  });

  final LoggerService _logger;

  /// Same Dio that owns this interceptor. Required before retries run.
  Dio? dio;

  /// Maximum number of retries to attempt.
  final int maxRetries;

  /// Base delay between retries in milliseconds.
  final Duration baseDelay;

  /// Status codes to retry on.
  final Set<int> retryStatusCodes;

  /// Only retry idempotent methods by default.
  final Set<String> retryMethods;

  /// The key to use for the retry count in the request options.
  final String retryCountExtraKey;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final client = dio;
    if (client == null) {
      _logger.w('RetryInterceptor: dio is null, skipping retries.');
      return handler.next(err);
    }

    if (!_shouldRetry(err)) {
      return handler.next(err);
    }

    final options = err.requestOptions;
    final retryCount = (options.extra[retryCountExtraKey] as int?) ?? 0;

    if (retryCount >= maxRetries) {
      _logger.w(
        'Retry exhausted ($maxRetries) for ${options.method} ${options.uri}',
      );
      return handler.next(err);
    }

    final nextAttempt = retryCount + 1;
    final delay = baseDelay * (1 << (nextAttempt - 1)); // 500, 1000, 2000...

    _logger.i(
      'Retrying ${options.method} ${options.uri} '
      '($nextAttempt/$maxRetries) after ${delay.inMilliseconds}ms',
    );

    await Future<void>.delayed(delay);

    options.extra[retryCountExtraKey] = nextAttempt;

    try {
      final response = await client.fetch<dynamic>(options);
      return handler.resolve(response);
    } on DioException catch (e) {
      return handler.next(e);
    } on Object catch (e, stackTrace) {
      _logger.e(
        'Error retrying ${options.method} ${options.uri}',
        error: e,
        stackTrace: stackTrace,
      );
      return handler.next(err);
    }
  }

  bool _shouldRetry(DioException err) {
    if (err.type == DioExceptionType.cancel) return false;
    final method = err.requestOptions.method.toUpperCase();
    if (!retryMethods.contains(method)) return false;
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError) {
      return true;
    }
    final status = err.response?.statusCode;
    return status != null && retryStatusCodes.contains(status);
  }
}
