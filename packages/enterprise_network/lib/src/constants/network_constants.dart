/// Shared network tokens: headers, JSON keys, request extras, and defaults.
class NetworkConstants {
  const NetworkConstants._();

  // ---------------------------------------------------------------------------
  // HTTP headers
  // ---------------------------------------------------------------------------

  /// `Content-Type` header name.
  static const String contentType = 'Content-Type';

  /// `Accept` header name.
  static const String accept = 'Accept';

  /// `Authorization` header name.
  static const String authorization = 'Authorization';

  /// JSON media type.
  static const String applicationJson = 'application/json';

  /// Bearer token prefix for [authorization].
  static const String bearerPrefix = 'Bearer ';

  /// Request timestamp header.
  static const String xTimestamp = 'X-Timestamp';

  /// Request correlation id header.
  static const String xCorrelationId = 'X-Correlation-Id';

  /// Client platform header.
  static const String platform = 'Platform';

  /// Client device model header.
  static const String deviceModel = 'Device-Model';

  /// Client OS version header.
  static const String osVersion = 'OS-Version';

  /// Client device id header.
  static const String deviceId = 'Device-Id';

  /// Preferred locale header.
  static const String acceptLanguage = 'Accept-Language';

  /// Default headers sent with each request.
  static const Map<String, String> defaultHeaders = {
    contentType: applicationJson,
    accept: applicationJson,
  };

  // ---------------------------------------------------------------------------
  // Response JSON keys
  // ---------------------------------------------------------------------------

  /// Primary payload key in wrapped API responses.
  static const String dataKey = 'data';

  /// Alternate list payload key.
  static const String itemsKey = 'items';

  /// Pagination metadata object key.
  static const String metaKey = 'meta';

  /// Current page number key.
  static const String pageKey = 'page';

  /// Alternate current page key.
  static const String currentPageKey = 'current_page';

  /// Page size key.
  static const String perPageKey = 'per_page';

  /// Alternate page size key.
  static const String perPageCountKey = 'per_page_count';

  /// Total item count key.
  static const String totalKey = 'total';

  /// Alternate total item count key.
  static const String totalCountKey = 'total_count';

  // ---------------------------------------------------------------------------
  // Request extra keys (Dio [RequestOptions.extra])
  // ---------------------------------------------------------------------------

  /// Skip auth for public endpoints.
  static const String skipAuthExtraKey = 'skip_auth';

  /// Marks token refresh calls to avoid refresh loops.
  static const String isRefreshCallExtraKey = 'is_refresh_call';

  /// Skip cache lookup/write for this request.
  static const String skipCacheExtraKey = 'skip_cache';

  /// Bypass cache and force a network fetch.
  static const String forceRefreshExtraKey = 'force_refresh';

  /// Response was served from cache.
  static const String cacheResponseExtraKey = 'cache_response';

  /// Cached response used as offline/error fallback.
  static const String isFallbackExtraKey = 'is_fallback';

  /// Retry attempt counter stored on Dio request extra options.
  static const String retryCountExtraKey = 'retry_count';

  // ---------------------------------------------------------------------------
  // HTTP methods
  // ---------------------------------------------------------------------------

  /// GET method (cacheable / idempotent).
  static const String getMethod = 'GET';

  /// HEAD method (idempotent).
  static const String headMethod = 'HEAD';

  /// OPTIONS method (idempotent).
  static const String optionsMethod = 'OPTIONS';

  /// Idempotent methods retried by default.
  static const Set<String> retryMethods = {
    getMethod,
    headMethod,
    optionsMethod,
  };

  // ---------------------------------------------------------------------------
  // Status codes
  // ---------------------------------------------------------------------------

  /// HTTP 200 OK.
  static const int successStatusCode = 200;

  /// HTTP 401 Unauthorized.
  static const int unauthorizedStatusCode = 401;

  /// Status codes retried by default.
  static const Set<int> retryStatusCodes = {408, 429, 500, 502, 503, 504};

  /// Treat status codes below this as non-throwing at the Dio level.
  static const int validateStatusBelow = 500;

  // ---------------------------------------------------------------------------
  // Defaults
  // ---------------------------------------------------------------------------

  /// Default connect timeout.
  static const Duration connectTimeout = Duration(seconds: 30);

  /// Default receive timeout.
  static const Duration receiveTimeout = Duration(seconds: 30);

  /// Default send timeout.
  static const Duration sendTimeout = Duration(seconds: 30);

  /// Default cache TTL when none is specified.
  static const Duration defaultCacheTtl = Duration(hours: 1);

  /// Base delay between retry attempts.
  static const Duration retryBaseDelay = Duration(milliseconds: 500);

  /// Default maximum retry attempts.
  static const int maxRetries = 3;

  /// Default page when pagination metadata is missing.
  static const int defaultPage = 1;

  /// Default page size when pagination metadata is missing.
  static const int defaultPerPage = 10;

  /// Default total when pagination metadata is missing.
  static const int defaultTotal = 0;
}
