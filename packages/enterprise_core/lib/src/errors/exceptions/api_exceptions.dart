import 'package:enterprise_core/src/errors/exceptions/app_exception.dart';

/// Base class for all API-related exceptions (HTTP status codes)
class ApiException extends AppException {
  /// Creates a base API exception with HTTP metadata.
  const ApiException({
    required super.message,
    required this.statusCode,
    super.code,
    super.stackTrace,
    super.details,
    this.endpoint,
    this.method,
    this.responseData,
    this.headers,
    super.severity = ErrorSeverity.medium,
  });

  /// HTTP status code
  final int statusCode;

  /// API endpoint that was called
  final String? endpoint;

  /// HTTP method used
  final String? method;

  /// Raw response data from the server
  final dynamic responseData;

  /// Response headers
  final Map<String, dynamic>? headers;

  /// Check if this is a client error (4xx)
  bool get isClientError => statusCode >= 400 && statusCode < 500;

  /// Check if this is a server error (5xx)
  bool get isServerError => statusCode >= 500 && statusCode < 600;

  /// Check if this is a validation error
  bool get isValidationError => statusCode == 400 || statusCode == 422;

  /// Check if this is an authentication error
  bool get isAuthenticationError => statusCode == 401;

  /// Check if this is a permission error
  bool get isPermissionError => statusCode == 403;

  /// Check if this is a not found error
  bool get isNotFound => statusCode == 404;

  /// Check if this is a conflict error
  bool get isConflict => statusCode == 409;

  /// Check if this is a rate limit error
  bool get isRateLimited => statusCode == 429;

  /// Check if request can be retried (server errors are retryable)
  bool get isRetryable =>
      isServerError || statusCode == 408 || statusCode == 429;

  /// Extract error message from response data
  String? get extractedMessage => _extractErrorMessage(responseData);

  /// Extract validation errors from response data
  Map<String, List<String>>? get validationErrors =>
      _extractValidationErrors(responseData);

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'statusCode': statusCode,
    'endpoint': endpoint,
    'method': method,
    'isRetryable': isRetryable,
    'extractedMessage': extractedMessage,
  };

  static String? _extractErrorMessage(dynamic data) {
    if (data is Map) {
      final raw =
          data['message'] ??
          data['error'] ??
          data['error_message'] ??
          data['detail'] ??
          data['msg'] ??
          data['error_description'];

      return raw?.toString();
    }
    if (data is String) {
      return data;
    }
    return null;
  }

  static Map<String, List<String>>? _extractValidationErrors(dynamic data) {
    if (data is Map) {
      // Handle different error formats
      if (data['errors'] is Map) {
        final errors = <String, List<String>>{};
        for (final entry in (data['errors'] as Map).entries) {
          final key = entry.key;
          final value = entry.value;
          if (value is List) {
            errors[key.toString()] = value.map((e) => e.toString()).toList();
          } else if (value is String) {
            errors[key.toString()] = [value];
          }
        }
        return errors;
      }

      // Handle Laravel-style errors
      if (data['errors'] is List) {
        final errors = <String, List<String>>{};
        for (final error in data['errors'] as List) {
          if (error is Map) {
            final field = error['field'] ?? error['param'] ?? error['property'];
            final message = error['message'];
            if (field != null && message != null) {
              errors.putIfAbsent(field.toString(), () => []);
              errors[field.toString()]!.add(message.toString());
            }
          }
        }
        return errors;
      }

      // Handle simple field errors
      final simpleErrors = <String, List<String>>{};
      for (final entry in data.entries) {
        final key = entry.key;
        final value = entry.value;
        if (value is String && key != 'message' && key != 'error') {
          simpleErrors[key.toString()] = [value];
        } else if (value is List && value.isNotEmpty && value.first is String) {
          simpleErrors[key.toString()] =
              value.map((e) => e.toString()).toList();
        }
      }
      return simpleErrors.isNotEmpty ? simpleErrors : null;
    }
    return null;
  }
}

/// Bad request exception (400)
class BadRequestException extends ApiException {
  /// Creates a 400 Bad Request exception.
  const BadRequestException({
    required super.message,
    super.responseData,
    super.headers,
    super.endpoint,
    super.method,
    super.stackTrace,
    super.details,
    this.validationErrors,
  }) : super(
         statusCode: 400,
         code: 'BAD_REQUEST',
         severity: ErrorSeverity.medium,
       );

  /// Builds a [BadRequestException] from response data and headers.
  factory BadRequestException.fromResponse({
    dynamic responseData,
    Map<String, dynamic>? headers,
    String? endpoint,
    String? method,
  }) {
    final validationErrors = ApiException._extractValidationErrors(
      responseData,
    );
    final message =
        ApiException._extractErrorMessage(responseData) ??
        'Invalid request. Please check your input.';

    return BadRequestException(
      message: message,
      responseData: responseData,
      headers: headers,
      endpoint: endpoint,
      method: method,
      validationErrors: validationErrors,
    );
  }

  /// Field-specific validation errors
  @override
  final Map<String, List<String>>? validationErrors;

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'validationErrors': validationErrors,
  };
}

/// Unauthorized exception (401)
class UnauthorizedRequestException extends ApiException {
  /// Creates a 401 Unauthorized exception.
  const UnauthorizedRequestException({
    super.message = 'Your session has expired. Please login again.',
    super.responseData,
    super.headers,
    super.endpoint,
    super.method,
    super.stackTrace,
    super.details,
    this.realm,
  }) : super(
         statusCode: 401,
         code: 'UNAUTHORIZED_REQUEST',
         severity: ErrorSeverity.high,
       );

  /// Builds a [UnauthorizedRequestException] from response data and headers.
  factory UnauthorizedRequestException.fromResponse({
    dynamic responseData,
    Map<String, dynamic>? headers,
    String? endpoint,
    String? method,
  }) {
    final message =
        ApiException._extractErrorMessage(responseData) ??
        'Your session has expired. Please login again.';

    String? realm;
    if (headers != null && headers['www-authenticate'] != null) {
      final authHeader = headers['www-authenticate'].toString();
      final realmMatch = RegExp('realm="([^"]+)"').firstMatch(authHeader);
      realm = realmMatch?.group(1);
    }

    return UnauthorizedRequestException(
      message: message,
      responseData: responseData,
      headers: headers,
      endpoint: endpoint,
      method: method,
      realm: realm,
    );
  }

  /// Authentication realm
  final String? realm;

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'realm': realm,
  };
}

/// Forbidden exception (403)
class ForbiddenException extends ApiException {
  /// Creates a 403 Forbidden exception.
  const ForbiddenException({
    super.message = "You don't have permission to access this resource.",
    super.responseData,
    super.headers,
    super.endpoint,
    super.method,
    super.stackTrace,
    super.details,
    this.requiredPermission,
  }) : super(
         statusCode: 403,
         code: 'FORBIDDEN',
         severity: ErrorSeverity.high,
       );

  /// Builds a [ForbiddenException] from response data and headers.
  factory ForbiddenException.fromResponse({
    dynamic responseData,
    Map<String, dynamic>? headers,
    String? endpoint,
    String? method,
  }) {
    final message =
        ApiException._extractErrorMessage(responseData) ??
        "You don't have permission to access this resource.";

    String? requiredPermission;
    if (responseData is Map && responseData['required_permission'] != null) {
      requiredPermission = responseData['required_permission'].toString();
    }

    return ForbiddenException(
      message: message,
      responseData: responseData,
      headers: headers,
      endpoint: endpoint,
      method: method,
      requiredPermission: requiredPermission,
    );
  }

  /// Required permission that was missing
  final String? requiredPermission;

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'requiredPermission': requiredPermission,
  };
}

/// Not found exception (404)
class ResourceNotFoundException extends ApiException {
  /// Creates a 404 Not Found exception.
  const ResourceNotFoundException({
    super.message = 'Resource not found.',
    super.responseData,
    super.headers,
    super.endpoint,
    super.method,
    super.stackTrace,
    super.details,
    this.resourceType,
    this.resourceId,
  }) : super(
         statusCode: 404,
         code: 'RESOURCE_NOT_FOUND',
         severity: ErrorSeverity.medium,
       );

  /// Builds a [ResourceNotFoundException] from response data and headers.
  factory ResourceNotFoundException.fromResponse({
    dynamic responseData,
    Map<String, dynamic>? headers,
    String? endpoint,
    String? method,
  }) {
    final message =
        ApiException._extractErrorMessage(responseData) ??
        'Resource not found.';

    String? resourceType;
    String? resourceId;
    if (responseData is Map) {
      resourceType = responseData['resource_type']?.toString();
      resourceId = responseData['resource_id']?.toString();
    }

    return ResourceNotFoundException(
      message: message,
      responseData: responseData,
      headers: headers,
      endpoint: endpoint,
      method: method,
      resourceType: resourceType,
      resourceId: resourceId,
    );
  }

  /// Type of resource that wasn't found
  final String? resourceType;

  /// ID of resource that wasn't found
  final String? resourceId;

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'resourceType': resourceType,
    'resourceId': resourceId,
  };
}

/// Conflict exception (409)
class ConflictException extends ApiException {
  /// Creates a 409 Conflict exception.
  const ConflictException({
    required super.message,
    super.responseData,
    super.headers,
    super.endpoint,
    super.method,
    super.stackTrace,
    super.details,
    this.conflictingField,
    this.conflictingValue,
  }) : super(
         statusCode: 409,
         code: 'CONFLICT',
         severity: ErrorSeverity.medium,
       );

  /// Builds a [ConflictException] from response data and headers.
  factory ConflictException.fromResponse({
    dynamic responseData,
    Map<String, dynamic>? headers,
    String? endpoint,
    String? method,
  }) {
    final message =
        ApiException._extractErrorMessage(responseData) ?? 'Resource conflict.';

    String? conflictingField;
    String? conflictingValue;
    if (responseData is Map) {
      conflictingField = responseData['field']?.toString();
      conflictingValue = responseData['value']?.toString();
    }

    return ConflictException(
      message: message,
      responseData: responseData,
      headers: headers,
      endpoint: endpoint,
      method: method,
      conflictingField: conflictingField,
      conflictingValue: conflictingValue,
    );
  }

  /// Field that caused the conflict
  final String? conflictingField;

  /// Value that caused the conflict
  final String? conflictingValue;

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'conflictingField': conflictingField,
    'conflictingValue': conflictingValue,
  };
}

/// Unprocessable entity exception (422)
class UnprocessableEntityException extends ApiException {
  /// Creates a 422 Unprocessable Entity exception.
  const UnprocessableEntityException({
    required super.message,
    super.responseData,
    super.headers,
    super.endpoint,
    super.method,
    super.stackTrace,
    super.details,
    this.validationErrors,
  }) : super(
         statusCode: 422,
         code: 'UNPROCESSABLE_ENTITY',
         severity: ErrorSeverity.medium,
       );

  /// Builds a [UnprocessableEntityException] from response data and headers.
  factory UnprocessableEntityException.fromResponse({
    dynamic responseData,
    Map<String, dynamic>? headers,
    String? endpoint,
    String? method,
  }) {
    final validationErrors = ApiException._extractValidationErrors(
      responseData,
    );
    final message =
        ApiException._extractErrorMessage(responseData) ?? 'Validation failed.';

    return UnprocessableEntityException(
      message: message,
      responseData: responseData,
      headers: headers,
      endpoint: endpoint,
      method: method,
      validationErrors: validationErrors,
    );
  }

  /// Validation errors
  @override
  final Map<String, List<String>>? validationErrors;

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'validationErrors': validationErrors,
  };
}

/// Rate limit exceeded exception (429)
class TooManyRequestsException extends ApiException {
  /// Creates a 429 Too Many Requests exception.
  const TooManyRequestsException({
    super.message = 'Too many requests. Please try again later.',
    super.responseData,
    super.headers,
    super.endpoint,
    super.method,
    super.stackTrace,
    super.details,
    this.limit,
    this.remaining,
    this.reset,
  }) : super(
         statusCode: 429,
         code: 'TOO_MANY_REQUESTS',
         severity: ErrorSeverity.low,
       );

  /// Builds a [TooManyRequestsException] from response data and headers.
  factory TooManyRequestsException.fromResponse({
    dynamic responseData,
    Map<String, dynamic>? headers,
    String? endpoint,
    String? method,
  }) {
    final message =
        ApiException._extractErrorMessage(responseData) ??
        'Too many requests. Please try again later.';

    int? limit;
    int? remaining;
    int? reset;

    if (headers != null) {
      limit = int.tryParse(headers['x-ratelimit-limit']?.toString() ?? '');
      remaining = int.tryParse(
        headers['x-ratelimit-remaining']?.toString() ?? '',
      );
      reset = int.tryParse(headers['x-ratelimit-reset']?.toString() ?? '');

      if (reset == null && headers['retry-after'] != null) {
        reset =
            DateTime.now().millisecondsSinceEpoch ~/ 1000 +
            (int.tryParse(headers['retry-after'].toString()) ?? 0);
      }
    }

    return TooManyRequestsException(
      message: message,
      responseData: responseData,
      headers: headers,
      endpoint: endpoint,
      method: method,
      limit: limit,
      remaining: remaining,
      reset: reset,
    );
  }

  /// Rate limit value
  final int? limit;

  /// Remaining requests
  final int? remaining;

  /// Time when limit resets (Unix timestamp)
  final int? reset;

  /// Get retry after duration
  Duration get retryAfter {
    if (reset != null) {
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final seconds = reset! - now;
      return Duration(seconds: seconds > 0 ? seconds : 0);
    }
    return const Duration(seconds: 60);
  }

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'limit': limit,
    'remaining': remaining,
    'reset': reset,
    'retryAfterSeconds': retryAfter.inSeconds,
  };
}

/// Internal server error exception (500)
class InternalServerErrorException extends ApiException {
  /// Creates a 500 Internal Server Error exception.
  const InternalServerErrorException({
    super.message = 'Internal server error. Please try again later.',
    super.responseData,
    super.headers,
    super.endpoint,
    super.method,
    super.stackTrace,
    super.details,
    this.errorId,
  }) : super(
         statusCode: 500,
         code: 'INTERNAL_SERVER_ERROR',
         severity: ErrorSeverity.high,
       );

  /// Builds a [InternalServerErrorException] from response data and headers.
  factory InternalServerErrorException.fromResponse({
    dynamic responseData,
    Map<String, dynamic>? headers,
    String? endpoint,
    String? method,
  }) {
    final message =
        ApiException._extractErrorMessage(responseData) ??
        'Internal server error. Please try again later.';

    String? errorId;
    if (responseData is Map && responseData['error_id'] != null) {
      errorId = responseData['error_id'].toString();
    }

    return InternalServerErrorException(
      message: message,
      responseData: responseData,
      headers: headers,
      endpoint: endpoint,
      method: method,
      errorId: errorId,
    );
  }

  /// Error tracking ID
  final String? errorId;

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'errorId': errorId,
  };
}

/// Service unavailable exception (503)
class ServiceUnavailableException extends ApiException {
  /// Creates a 503 Service Unavailable exception.
  const ServiceUnavailableException({
    super.message = 'Service temporarily unavailable. Please try again later.',
    super.responseData,
    super.headers,
    super.endpoint,
    super.method,
    super.stackTrace,
    super.details,
    this.retryAfterSeconds = 60,
  }) : super(
         statusCode: 503,
         code: 'SERVICE_UNAVAILABLE',
         severity: ErrorSeverity.high,
       );

  /// Builds a [ServiceUnavailableException] from response data and headers.
  factory ServiceUnavailableException.fromResponse({
    dynamic responseData,
    Map<String, dynamic>? headers,
    String? endpoint,
    String? method,
  }) {
    final message =
        ApiException._extractErrorMessage(responseData) ??
        'Service temporarily unavailable. Please try again later.';

    var retryAfterSeconds = 60;
    if (headers != null && headers['retry-after'] != null) {
      retryAfterSeconds = int.tryParse(headers['retry-after'].toString()) ?? 60;
    }

    return ServiceUnavailableException(
      message: message,
      responseData: responseData,
      headers: headers,
      endpoint: endpoint,
      method: method,
      retryAfterSeconds: retryAfterSeconds,
    );
  }

  /// Seconds to wait before retrying
  final int retryAfterSeconds;

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'retryAfterSeconds': retryAfterSeconds,
  };
}
