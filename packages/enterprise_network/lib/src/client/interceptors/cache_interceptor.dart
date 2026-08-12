import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:enterprise_logger/enterprise_logger.dart';
import 'package:enterprise_network/src/client/cache/network_cache_store.dart';
import 'package:enterprise_network/src/constants/network_constants.dart';
/*Call	Meaning
handler.next(options)
Continue to the next interceptor / real HTTP call
handler.resolve(response)
Stop here; treat this as a successful response (no network)
handler.reject(error)
Fail the request now
*/
/// Interceptor to cache network responses.
class CacheInterceptor extends Interceptor {
  /// Constructor for the CacheInterceptor.
  CacheInterceptor(
    this._logger,
    this._cacheStore, {
    this.defaultTtl = NetworkConstants.defaultCacheTtl,
    this.skipCacheExtraKey = NetworkConstants.skipCacheExtraKey,
    this.forceRefreshExtraKey = NetworkConstants.forceRefreshExtraKey,
    this.cacheBoxHint = 'api_cache',
    this.cacheResponseExtraKey = NetworkConstants.cacheResponseExtraKey,
    this.isFallbackExtraKey = NetworkConstants.isFallbackExtraKey,
  });

  final NetworkCacheStore _cacheStore;
  final LoggerService _logger;

  /// Default TTL for cached responses.
  final Duration defaultTtl;

  /// Extra key to skip caching.
  final String skipCacheExtraKey;

  /// Extra key to force refresh.
  final String forceRefreshExtraKey;

  /// Extra key to indicate that the response is cached.
  final String cacheResponseExtraKey;

  /// Extra key to indicate that the response is a fallback.
  final String isFallbackExtraKey;

  /// Passed through for app stores that use Hive boxes (optional).
  final String cacheBoxHint;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!_shouldUseCache(options) ||
        options.extra[forceRefreshExtraKey] == true) {
      return handler.next(options);
    }

    final key = _cacheKey(options);
    try {
      final cached = await _cacheStore.read(key);
      if (cached == null) return handler.next(options);

      final data = jsonDecode(cached);
      return handler.resolve(
        Response<dynamic>(
          requestOptions: options,
          data: data,
          statusCode: NetworkConstants.successStatusCode,
          extra: {
            ...options.extra,
            cacheResponseExtraKey: true,
          },
        ),
      );
    } on Object catch (e, stackTrace) {
      _logger.e('Error reading cache: $key', error: e, stackTrace: stackTrace);
      return handler.next(options);
    }
  }

  @override
  Future<void> onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) async {
    final options = response.requestOptions;
    if (_shouldUseCache(options) &&
        response.statusCode == NetworkConstants.successStatusCode &&
        response.data != null) {
      final key = _cacheKey(options);
      try {
        await _cacheStore.write(
          key,
          jsonEncode(response.data),
          ttl: defaultTtl,
        );
        response.extra[cacheResponseExtraKey] = true;
      } on Object catch (e, stackTrace) {
        _logger.e(
          'Error writing cache: $key',
          error: e,
          stackTrace: stackTrace,
        );
      }
      handler.next(response);
    }
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final options = err.requestOptions;
    if (!_shouldUseCache(options)) {
      return handler.next(err);
    }

    final key = _cacheKey(options);
    try {
      final cached = await _cacheStore.read(key);
      if (cached == null) return handler.next(err);
      
      final data = jsonDecode(cached);
      return handler.resolve(
        Response<dynamic>(
          requestOptions: options,
          data: data,
          statusCode: NetworkConstants.successStatusCode,
          extra: {
            ...options.extra,
            cacheResponseExtraKey: true,
            isFallbackExtraKey: true,
          },
        ),
      );
    } on Object catch (e, stackTrace) {
      _logger.e('Error reading cache: $key', error: e, stackTrace: stackTrace);
      return handler.next(err);
    }
  }

  bool _shouldUseCache(RequestOptions options) {
    if (options.method.toUpperCase() != NetworkConstants.getMethod) {
      return false;
    }
    if (options.extra[skipCacheExtraKey] == true) return false;
    return true;
  }

  String _cacheKey(RequestOptions options) {
    final keys = options.queryParameters.keys.toList()..sort();
    final query = keys.map((k) => '$k=${options.queryParameters[k]}').join('&');
    return '${options.method}_${options.uri.path}_$query';
  }
}
