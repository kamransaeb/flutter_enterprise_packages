import 'package:enterprise_core/src/errors/exceptions/app_exception.dart';

/// Base cache exception
class CacheException extends AppException {
  const CacheException({
    required super.message,
    super.code = 'CACHE_ERROR',
    super.stackTrace,
    super.details,
    this.key,
    this.operation,
    super.severity = ErrorSeverity.low,
  });

  /// Cache key being accessed
  final String? key;

  /// Operation being performed (read, write, delete)
  final String? operation;
}

/// Cache read exception
class CacheReadException extends CacheException {
  const CacheReadException({
    required super.message,
    super.key,
    super.stackTrace,
    super.details,
  }) : super(
          operation: 'read',
          code: 'CACHE_READ_ERROR',
        );
}

/// Cache write exception
class CacheWriteException extends CacheException {
  const CacheWriteException({
    required super.message,
    super.key,
    super.stackTrace,
    super.details,
  }) : super(
          operation: 'write',
          code: 'CACHE_WRITE_ERROR',
        );
}

/// Cache delete exception
class CacheDeleteException extends CacheException {
  const CacheDeleteException({
    required super.message,
    super.key,
    super.stackTrace,
    super.details,
  }) : super(
          operation: 'delete',
          code: 'CACHE_DELETE_ERROR',
        );
}

/// Cache corrupted exception
class CacheCorruptedException extends CacheException {
  const CacheCorruptedException({
    String message = 'Cache data is corrupted.',
    super.key,
    super.stackTrace,
    super.details,
    this.corruptedData,
  }) : super(
          message: message,
          operation: 'read',
          code: 'CACHE_CORRUPTED',
          severity: ErrorSeverity.medium,
        );

  /// The corrupted data that caused the error
  final dynamic corruptedData;
}

/// Cache full exception
class CacheFullException extends CacheException {
  const CacheFullException({
    String message = 'Cache storage is full.',
    super.key,
    super.stackTrace,
    super.details,
    this.requiredSpace,
    this.availableSpace,
  }) : super(
          message: message,
          operation: 'write',
          code: 'CACHE_FULL',
          severity: ErrorSeverity.medium,
        );

  /// Space required for operation
  final int? requiredSpace;

  /// Available space in cache
  final int? availableSpace;
}

/// Cache not initialized exception
class CacheNotInitializedException extends CacheException {
  const CacheNotInitializedException({
    String message = 'Cache has not been initialized.',
    super.key,
    super.stackTrace,
    super.details,
  }) : super(
          message: message,
          operation: 'initialize',
          code: 'CACHE_NOT_INITIALIZED',
          severity: ErrorSeverity.high,
        );
}

/// Cache timeout exception
class CacheTimeoutException extends CacheException {
  const CacheTimeoutException({
    String message = 'Cache operation timed out.',
    super.key,
    super.operation,
    super.stackTrace,
    super.details,
    this.timeoutDuration,
  }) : super(
          message: message,
          code: 'CACHE_TIMEOUT',
          severity: ErrorSeverity.low,
        );

  /// Duration that was exceeded
  final Duration? timeoutDuration;
}