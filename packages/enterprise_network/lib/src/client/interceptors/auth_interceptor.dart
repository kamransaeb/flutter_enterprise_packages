import 'dart:async';

import 'package:dio/dio.dart';
import 'package:enterprise_logger/enterprise_logger.dart';

/// A function that reads the token from the storage.
typedef TokenReader = Future<String?> Function();

/// A function that refreshes the token.
typedef TokenRefresher = Future<String?> Function();

/// A function that handles the expired token.
typedef TokenExpiredHandler = Future<String?> Function();

/// Attaches Bearer tokens and refreshes once on HTTP 401.
///
/// Extends [QueuedInterceptor] so auth callbacks are serialized by Dio.
/// A shared [Completer] ensures concurrent 401s wait on the **same** refresh.
///
/// Storage / refresh HTTP stay in the app via callbacks — no secure storage here.
class AuthInterceptor extends QueuedInterceptor {
  /// Creates a new [AuthInterceptor].
  AuthInterceptor(
    this._logger,
    this._getAccessToken,
    this._refreshTokens,
    this._onTokenExpired, {
    this.skipAuthExtraKey = 'skipAuth',
    this.isRefreshCallExtraKey = 'isRefreshCall',
  });

  /// The logger to be used.
  final LoggerService _logger;

  /// A function that reads the token from the storage.
  final TokenReader _getAccessToken;

  /// A function that refreshes the token.
  final TokenRefresher _refreshTokens;

  /// A function that handles the expired token.
  final TokenExpiredHandler _onTokenExpired;

  /// Set `options.extra[skipAuthExtraKey] = true` for public endpoints.
  final String skipAuthExtraKey;

  /// The key to use for the is refresh call in the request options.
  final String isRefreshCallExtraKey;

  /// The Dio instance to be used.
  /// Set by the client app.
  Dio? dio;

  // A Completer<T> is a Dart object that lets you create and complete a
  // Future<T> manually.
  // Normally a Future finishes when an asyn function returns or an API 
  // resolves. With a Completer you can:
  // 1. Create: final c = Completer<String?>();
  // 2. Hand out: c.future to waiters.
  /// In-flight refresh shared by concurrent 401 handlers.
  Completer<String?>? _refreshCompleter;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final skipAuth = options.extra[skipAuthExtraKey] as bool? ?? false;
    if (skipAuth) {
      return handler.next(options);
    }

    try {
      final accessToken = await _getAccessToken();
      if (accessToken != null && accessToken.isNotEmpty) {
        options.headers['Authroization'] = 'Bearer $accessToken';
      }
      handler.next(options);
    } on Object catch (e, stackTrace) {
      _logger.e('Auth onRequest error', error: e, stackTrace: stackTrace);
      handler.next(options);
    }
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    // Avoid refresh loop on the refresh access token endpoint.
    if (err.requestOptions.extra[isRefreshCallExtraKey] as bool? ?? false) {
      await _onTokenExpired();
      return handler.next(err);
    }

    final client = dio;
    if (client == null) {
      _logger.w(
        'AuthInterceptor: Dio instance is null, cannot retry after refresh',
      );
      return handler.next(err);
    }

    // When several API calls fail with 401 at once:
    // 1. You must refresh the token only once.
    // 2. Other failed calls must wait, then retry
    // QueuedInterceptor already serializes; still safe to wait/retry below
    try {
      final newToken = await _refreshAccessToken();
      if (newToken == null || newToken.isEmpty) {
        await _onTokenExpired();
        return handler.next(err);
      }
      final requestOptions = err.requestOptions;
      requestOptions.headers['Authorization'] = 'Bearer $newToken';
      final response = await client.fetch<dynamic>(requestOptions);
      return handler.resolve(response);
    } on DioException catch (e) {
      await _onTokenExpired();
      return handler.next(e);
    } on Object catch (e, stackTrace) {
      _logger.e('Token refresh failed', error: e, stackTrace: stackTrace);
      await _onTokenExpired();
      return handler.next(err);
    }
  }

  /// Single-flight refresh: waiters share the same [Completer] future.
  Future<String?> _refreshAccessToken() async {
    final inFlight = _refreshCompleter;
    if (inFlight != null) {
      return inFlight.future;
    }

    final completer = Completer<String?>();
    _refreshCompleter = completer;

    try {
      final token = await _refreshTokens();
      completer.complete(token);
      return token;
    } on Object catch (e, stackTrace) {
      completer.completeError(e, stackTrace);
      rethrow;
    } finally {
      // Clear the completer to allow new refresh attempts.
      _refreshCompleter = null;
    }
  }
}
