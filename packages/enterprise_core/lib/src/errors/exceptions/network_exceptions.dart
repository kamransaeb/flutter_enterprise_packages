import 'package:enterprise_core/src/errors/exceptions/app_exception.dart';

/// Base network connectivity exception (low-level network issues)
class NetworkException extends AppException {
  /// Creates a [NetworkException].
  const NetworkException({
    required super.message,
    super.code = 'NETWORK_ERROR',
    super.stackTrace,
    super.details,
    this.retryable = true,
    this.endpoint,
    this.method,
    super.severity = ErrorSeverity.medium,
  });

  /// Whether the operation can be retried
  final bool retryable;

  /// The API endpoint that was called (if applicable)
  final String? endpoint;

  /// HTTP method used (if applicable)
  final String? method;

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'retryable': retryable,
    'endpoint': endpoint,
    'method': method,
  };
}

/// No internet connection exception
class NoInternetConnectionException extends NetworkException {
  /// Creates a [NoInternetConnectionException].
  const NoInternetConnectionException({
    super.message = 'No internet connection. Please check your network.',
    super.code = 'NO_INTERNET_CONNECTION',
    super.stackTrace,
    super.details,
    super.endpoint,
    super.method,
    super.retryable = true,
    super.severity = ErrorSeverity.high,
  });
}

/// Response parsing error
class ResponseParsingException extends NetworkException {
  /// Creates a [ResponseParsingException].
  const ResponseParsingException({
    required super.message,
    super.code = 'RESPONSE_PARSING_ERROR',
    super.stackTrace,
    super.details,
    super.endpoint,
    super.method,
    this.rawResponse,
    this.expectedType,
    super.retryable = false,
    super.severity = ErrorSeverity.medium,
  });

  /// Creates a [ResponseParsingException].
  factory ResponseParsingException.invalidJson({
    required dynamic rawResponse,
    required String message,
    String? endpoint,
  }) {
    return ResponseParsingException(
      message: 'Invalid JSON response: $message',
      rawResponse: rawResponse,
      endpoint: endpoint,
      expectedType: Map,
    );
  }

  /// Creates a [ResponseParsingException].
  factory ResponseParsingException.unexpectedType({
    required Type expected,
    required Type actual,
    dynamic rawResponse,
    String? endpoint,
  }) {
    return ResponseParsingException(
      message: 'Unexpected response type: expected $expected, got $actual',
      rawResponse: rawResponse,
      endpoint: endpoint,
      expectedType: expected,
    );
  }

  /// Raw response that failed to parse
  final dynamic rawResponse;

  /// Expected type during parsing
  final Type? expectedType;
}

/// HTTP status error (non-2xx status codes)
class HttpStatusException extends NetworkException {
  /// Creates a [HttpStatusException].
  const HttpStatusException({
    required super.message,
    required this.statusCode,
    super.code = 'HTTP_STATUS_ERROR',
    super.stackTrace,
    super.details,
    super.endpoint,
    super.method,
    this.responseData,
  }) : super(
         retryable: statusCode >= 500 || statusCode == 408 || statusCode == 429,
         severity: statusCode >= 500 || statusCode == 401 || statusCode == 403
             ? ErrorSeverity.high
             : statusCode >= 400
             ? ErrorSeverity.medium
             : ErrorSeverity.low,
       );

  /// HTTP status code
  final int statusCode;

  /// Response data from the server
  final dynamic responseData;

  /// Check if this is a client error (4xx)
  bool get isClientError => statusCode >= 400 && statusCode < 500;

  /// Check if this is a server error (5xx)
  bool get isServerError => statusCode >= 500 && statusCode < 600;

  /// Check if this is a rate limit error
  bool get isRateLimited => statusCode == 429;

  /// Check if this is an authentication error
  bool get isAuthenticationError => statusCode == 401;

  /// Check if this is a permission error
  bool get isPermissionError => statusCode == 403;

  /// Check if this is a not found error
  bool get isNotFound => statusCode == 404;
}

/// Connection timeout exception
class ConnectionTimeoutException extends NetworkException {
  /// Creates a [ConnectionTimeoutException].
  const ConnectionTimeoutException({
    super.message = 'Connection timeout. Please try again.',
    super.code = 'CONNECTION_TIMEOUT',
    super.stackTrace,
    super.details,
    super.endpoint,
    super.method,
    this.timeoutDuration,
    super.retryable = true,
    super.severity = ErrorSeverity.medium,
  });

  /// Creates a [ConnectionTimeoutException].
  factory ConnectionTimeoutException.withDuration({
    required Duration duration,
    String? endpoint,
    String? method,
  }) {
    return ConnectionTimeoutException(
      message: 'Connection timeout after ${duration.inSeconds} seconds',
      timeoutDuration: duration,
      endpoint: endpoint,
      method: method,
    );
  }

  /// Duration that was exceeded
  final Duration? timeoutDuration;

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'timeoutDuration': timeoutDuration?.inSeconds,
  };
}

/// DNS resolution failed exception
class DnsResolutionException extends NetworkException {
  /// Creates a [DnsResolutionException].
  const DnsResolutionException({
    required this.hostname,
    String message = 'Failed to resolve DNS',
    super.code = 'DNS_RESOLUTION_FAILED',
    super.stackTrace,
    super.details,
    super.endpoint,
    super.method,
  }) : super(
         message: '$message: $hostname',
         retryable: true,
         severity: ErrorSeverity.medium,
       );

  /// Hostname that failed to resolve
  final String hostname;

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'hostname': hostname,
  };
}

/// SSL/TLS certificate error exception
class SslException extends NetworkException {
  /// Creates a [SslException].
  const SslException({
    required super.message,
    super.code = 'SSL_ERROR',
    super.stackTrace,
    super.details,
    super.endpoint,
    super.method,
    this.certificateSubject,
    this.certificateIssuer,
    this.certificateExpiryDate,
    super.retryable = false,
    super.severity = ErrorSeverity.high,
  });

  /// Creates a [SslException].
  factory SslException.certificateExpired({
    required String subject,
    required DateTime expiryDate,
    String? endpoint,
    String? method,
  }) {
    return SslException(
      message: 'SSL certificate expired on $expiryDate',
      certificateSubject: subject,
      certificateExpiryDate: expiryDate,
      endpoint: endpoint,
      method: method,
      code: 'SSL_CERTIFICATE_EXPIRED',
    );
  }

  /// Creates a [SslException].
  factory SslException.hostnameMismatch({
    required String expectedHost,
    required String actualHost,
    String? endpoint,
    String? method,
  }) {
    return SslException(
      message: 'SSL certificate hostname mismatch: expected '
          '$expectedHost, got $actualHost.',
      certificateSubject: actualHost,
      endpoint: endpoint,
      method: method,
      code: 'SSL_HOSTNAME_MISMATCH',
    );
  }

  /// Creates a [SslException].
  factory SslException.untrustedCertificate({
    required String subject,
    String? issuer,
    String? endpoint,
    String? method,
  }) {
    return SslException(
      message: 'SSL certificate is not trusted',
      certificateSubject: subject,
      certificateIssuer: issuer,
      endpoint: endpoint,
      method: method,
      code: 'SSL_UNTRUSTED_CERTIFICATE',
    );
  }

  /// Certificate subject
  final String? certificateSubject;

  /// Certificate issuer
  final String? certificateIssuer;

  /// Certificate expiry date
  final DateTime? certificateExpiryDate;

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'certificateSubject': certificateSubject,
    'certificateIssuer': certificateIssuer,
    'certificateExpiryDate': certificateExpiryDate?.toIso8601String(),
  };
}

/// Network unreachable exception
class NetworkUnreachableException extends NetworkException {
  /// Creates a [NetworkUnreachableException].
  const NetworkUnreachableException({
    super.message = 'Network is unreachable',
    super.code = 'NETWORK_UNREACHABLE',
    super.stackTrace,
    super.details,
    super.endpoint,
    super.method,
    super.retryable = true,
    super.severity = ErrorSeverity.high,
  });
}

/// Socket exception (low-level socket errors)
class SocketException extends NetworkException {
  /// Creates a [SocketException].
  const SocketException({
    required super.message,
    super.code = 'SOCKET_ERROR',
    super.stackTrace,
    super.details,
    super.endpoint,
    super.method,
    this.port,
    this.address,
    super.retryable = true,
    super.severity = ErrorSeverity.medium,
  });

  /// Creates a [SocketException].
  factory SocketException.connectionRefused({
    String? address,
    int? port,
    String? endpoint,
  }) {
    return SocketException(
      message: 'Connection refused'
          '${address != null ? ' to $address' : ''}'
          '${port != null ? ':$port' : ''}',
      address: address,
      port: port,
      endpoint: endpoint,
      code: 'SOCKET_CONNECTION_REFUSED',
    );
  }

  /// Port number
  final int? port;

  /// IP address
  final String? address;

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'port': port,
    'address': address,
  };
}

/// WebSocket connection error
class WebSocketException extends NetworkException {
  /// Creates a [WebSocketException].
  const WebSocketException({
    required super.message,
    super.code = 'WEBSOCKET_ERROR',
    super.stackTrace,
    super.details,
    super.endpoint,
    this.closeCode,
    this.closeReason,
    super.retryable = true,
    super.severity = ErrorSeverity.medium,
  });

  /// Creates a [WebSocketException].
  factory WebSocketException.connectionClosed({
    required int code,
    required String reason,
    String? endpoint,
  }) {
    return WebSocketException(
      message: 'WebSocket connection closed: $reason (Code: $code)',
      closeCode: code,
      closeReason: reason,
      endpoint: endpoint,
    );
  }

  /// Creates a [WebSocketException].
  factory WebSocketException.connectionFailed({
    required String reason,
    String? endpoint,
  }) {
    return WebSocketException(
      message: 'WebSocket connection failed: $reason',
      closeReason: reason,
      endpoint: endpoint,
      code: 'WEBSOCKET_CONNECTION_FAILED',
    );
  }

  /// WebSocket close code
  final int? closeCode;

  /// WebSocket close reason
  final String? closeReason;

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'closeCode': closeCode,
    'closeReason': closeReason,
  };
}

/// Request cancelled exception (network-level cancellation)
class RequestCancelledException extends NetworkException {
  /// Creates a [RequestCancelledException].
  const RequestCancelledException({
    super.message = 'Request was cancelled',
    super.code = 'REQUEST_CANCELLED',
    super.stackTrace,
    super.details,
    super.endpoint,
    super.method,
    super.retryable = false,
    super.severity = ErrorSeverity.low,
  });
}
