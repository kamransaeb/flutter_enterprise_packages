/// Base exception class for all application-specific exceptions.
/// 
/// This class provides a foundation for all custom exceptions in the app,
/// ensuring consistent error handling, logging, and reporting.
abstract class AppException implements Exception {
  const AppException({
    required this.message,
    this.code,
    this.stackTrace,
    this.details,
    this.severity = ErrorSeverity.medium,
  });

  /// Human-readable error message
  final String message;

  /// Error code for categorization and analytics
  final String? code;

  /// Stack trace for debugging
  final StackTrace? stackTrace;

  /// Additional error context and metadata
  final Map<String, dynamic>? details;

  /// Error severity level
  final ErrorSeverity severity;

  @override
  String toString() {
    final buffer = StringBuffer('[$runtimeType] ');
    buffer.write(message);
    if (code != null) buffer.write(' (Code: $code)');
    if (details != null && details!.isNotEmpty) {
      buffer.write(' | Details: $details');
    }
    return buffer.toString();
  }

  /// Convert exception to JSON for logging/analytics
  Map<String, dynamic> toJson() => {
        'type': runtimeType.toString(),
        'message': message,
        'code': code,
        'details': details,
        'severity': severity.name,
        'timestamp': DateTime.now().toIso8601String(),
      };

  /// Create a copy with updated fields
  AppException copyWith({
    String? message,
    String? code,
    StackTrace? stackTrace,
    Map<String, dynamic>? details,
    ErrorSeverity? severity,
  }) {
    return _CopyException(
      message: message ?? this.message,
      code: code ?? this.code,
      stackTrace: stackTrace ?? this.stackTrace,
      details: details ?? this.details,
      severity: severity ?? this.severity,
      originalException: this,
    );
  }
}

/// Internal class for copying exceptions
class _CopyException extends AppException {
  _CopyException({
    required super.message,
    super.code,
    super.stackTrace,
    super.details,
    super.severity,
    required this.originalException,
  });

  final AppException originalException;
}

/// Error severity levels for prioritizing error handling and reporting
enum ErrorSeverity {
  /// Low priority - user can continue using the app
  low,

  /// Medium priority - user experience affected but app functional
  medium,

  /// High priority - critical error requiring immediate attention
  high,

  /// Critical - app crash or data loss risk
  critical,
}