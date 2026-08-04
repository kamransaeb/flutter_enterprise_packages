import 'package:dio/dio.dart';
import 'package:enterprise_core/src/errors/exceptions.dart';
import 'package:enterprise_core/src/errors/failures.dart';
import 'package:enterprise_logger/enterprise_logger.dart';

/// Optional callback used by the app layer (e.g. Firebase, Sentry).
///
/// Keep crash reporting out of enterprise_core, inject it from consumer app.
typedef ErrorReporter =
    void Function(
      Object error, {
      StackTrace? stackTrace,
      String? reason,
      bool fatal,
      Map<String, dynamic>? extra,
    });

/// Maps errors to [Failure]s and optionally logs / reports them.
///
/// Package-safe: no AppConfig, DI, Firebase, or Sentry.
class ErrorHandler {
  /// Creates a new [ErrorHandler] instance.
  const ErrorHandler(
    this._loggerService,{
    this.enableLogging = true,
    this.errorReporter,
  });

  final LoggerService _loggerService;

  /// Whether to enable logging of errors.
  final bool enableLogging;

  /// Optional callback used by the app layer (e.g. Firebase, Sentry).
  final ErrorReporter? errorReporter;

  /// Handles any error and converts it to a [Failure]
  Failure handleError(
    Object error, {
    StackTrace? stackTrace,
    String reason = 'error_handling',
    bool report = true,
  }) {
    _logError(error, stackTrace);
    if (report) {
      _report(
        error,
        stackTrace: stackTrace,
        reason: reason,
      );
    }

    if (error is AppException) {
      return _handleAppException(error);
    }
    if (error is DioException) {
      return _handleDioException(error);
    }
    if (error is FormatException) {
      return ValidationFailure(
        message: 'Invalid data format received',
        code: 'FORMAT_ERROR',
        details: {'error': error.toString()},
      );
    }
    if (error is Exception) {
      return ServerFailure(
        message: error.toString(),
        code: 'EXCEPTION',
        retryable: false,
      );
    }
    return UnknownFailure(
      details: {'error': error.toString()},
    );
  }

  /// Manually capture an error
  void captureError(
    Object error, {
    StackTrace? stackTrace,
    String? reason,
    bool fatal = false,
    Map<String, dynamic>? extra,
  }) {
    final resolvedStackTrace = stackTrace ?? StackTrace.current;
    _logError(error, stackTrace);
    _report(
      error,
      stackTrace: resolvedStackTrace,
      reason: reason,
      fatal: fatal,
      extra: extra,
    );
  }

  /// Log a non-fatal error
  void logNonFatalError(
    Object error, {
    StackTrace? stackTrace,
    String? reason,
    Map<String, dynamic>? extra,
  }) {
    captureError(
      error,
      stackTrace: stackTrace,
      reason: reason ?? 'non_fatal_error',
      extra: extra,
    );
  }

  void _report(
    Object error, {
    StackTrace? stackTrace,
    String? reason,
    bool fatal = false,
    Map<String, dynamic>? extra,
  }) {
    try {
      errorReporter?.call(
        error,
        stackTrace: stackTrace,
        reason: reason,
        fatal: fatal,
        extra: extra,
      );
    } on Object catch (e, stackTrace) {
      if (enableLogging) {
        _loggerService.e(
          'Failed to report error',
          error: e,
          stackTrace: stackTrace,
        );
      }
    }
  }

  void _logError(Object error, StackTrace? stackTrace) {
    if (!enableLogging) return;
    _loggerService.e(
      'Error: $error',
      error: error,
      stackTrace: stackTrace,
    );
  }

  Failure _handleAppException(AppException exception) {
    switch (exception) {
      // ============================================================
      // Network exceptions
      // ============================================================
      case final NoInternetConnectionException ex:
        //final ex = exception as NoInternetConnectionException;
        return NoInternetConnectionFailure(
          message: exception.message,
          endpoint: ex.endpoint,
          method: ex.method,
          details: exception.details,
        );
      case final ConnectionTimeoutException ex:
        return ConnectionTimeoutFailure(
          message: exception.message,
          timeoutDuration: ex.timeoutDuration,
          endpoint: ex.endpoint,
          method: ex.method,
          details: exception.details,
        );
      case final DnsResolutionException ex:
        return DnsResolutionFailure(
          message: exception.message,
          hostname: ex.message.split(':').last.trim(),
          endpoint: ex.endpoint,
          method: ex.method,
          details: exception.details,
        );
      case final SslException ex:
        return SslFailure(
          message: exception.message,
          certificateSubject: ex.certificateSubject,
          certificateIssuer: ex.certificateIssuer,
          certificateExpiryDate: ex.certificateExpiryDate,
          endpoint: ex.endpoint,
          method: ex.method,
          details: exception.details,
        );
      case final NetworkUnreachableException ex:
        return NetworkUnreachableFailure(
          message: exception.message,
          endpoint: ex.endpoint,
          method: ex.method,
          details: exception.details,
        );
      case final SocketException ex:
        return SocketFailure(
          message: exception.message,
          port: ex.port,
          address: ex.address,
          endpoint: ex.endpoint,
          method: ex.method,
          details: exception.details,
        );
      case final WebSocketException ex:
        return WebSocketFailure(
          message: exception.message,
          closeCode: ex.closeCode,
          closeReason: ex.closeReason,
          endpoint: ex.endpoint,
          details: exception.details,
        );
      case final RequestCancelledException ex:
        return RequestCancelledFailure(
          message: exception.message,
          endpoint: ex.endpoint,
          method: ex.method,
          details: exception.details,
        );

      case final HttpStatusException ex:
        return HttpStatusFailure(
          message: exception.message,
          statusCode: ex.statusCode,
          endpoint: ex.endpoint,
          method: ex.method,
          responseData: ex.responseData,
          details: exception.details,
        );

      case final ResponseParsingException ex:
        return ResponseParsingFailure(
          message: exception.message,
          rawResponse: ex.rawResponse,
          expectedType: ex.expectedType,
          endpoint: ex.endpoint,
          method: ex.method,
          details: exception.details,
        );

      // ============================================================
      // API exceptions
      // ============================================================
      case final BadRequestException ex:
        return BadRequestFailure(
          message: exception.message,
          validationErrors: ex.validationErrors,
          endpoint: ex.endpoint,
          method: ex.method,
          responseData: ex.responseData,
          details: exception.details,
        );

      case final UnauthorizedRequestException ex:
        return UnauthorizedRequestFailure(
          message: exception.message,
          validationErrors: ex.validationErrors,
          endpoint: ex.endpoint,
          method: ex.method,
          responseData: ex.responseData,
          details: exception.details,
        );

      case final ForbiddenException ex:
        return ForbiddenFailure(
          message: exception.message,
          requiredPermission: ex.requiredPermission,
          endpoint: ex.endpoint,
          method: ex.method,
          responseData: ex.responseData,
          details: exception.details,
        );

      case final ResourceNotFoundException ex:
        return ResourceNotFoundFailure(
          message: exception.message,
          resourceType: ex.resourceType,
          resourceId: ex.resourceId,
          endpoint: ex.endpoint,
          method: ex.method,
          responseData: ex.responseData,
          details: exception.details,
        );

      case final ConflictException ex:
        return ConflictFailure(
          message: exception.message,
          conflictingField: ex.conflictingField,
          conflictingValue: ex.conflictingValue,
          endpoint: ex.endpoint,
          method: ex.method,
          responseData: ex.responseData,
          details: exception.details,
        );

      case final UnprocessableEntityException ex:
        return UnprocessableEntityFailure(
          message: exception.message,
          validationErrors: ex.validationErrors,
          endpoint: ex.endpoint,
          method: ex.method,
          responseData: ex.responseData,
          details: exception.details,
        );

      case final TooManyRequestsException ex:
        return TooManyRequestsFailure(
          message: exception.message,
          limit: ex.limit,
          remaining: ex.remaining,
          reset: ex.reset,
          endpoint: ex.endpoint,
          method: ex.method,
          responseData: ex.responseData,
          details: exception.details,
        );

      case final InternalServerErrorException ex:
        return InternalServerErrorFailure(
          message: exception.message,
          errorId: ex.errorId,
          endpoint: ex.endpoint,
          method: ex.method,
          responseData: ex.responseData,
          details: exception.details,
        );

      case final ServiceUnavailableException ex:
        return ServiceUnavailableFailure(
          message: exception.message,
          retryAfterSeconds: ex.retryAfterSeconds,
          endpoint: ex.endpoint,
          method: ex.method,
          responseData: ex.responseData,
          details: exception.details,
        );

      // ============================================================
      // Serialization exceptions
      // ============================================================
      case final JsonSerializationException ex:
        return JsonSerializationFailure(
          message: exception.message,
          jsonPath: ex.jsonPath,
          expectedType: ex.expectedType,
          actualType: ex.actualType,
          type: ex.type,
          data: ex.data,
          details: exception.details,
        );
      case final JsonDeserializationException ex:
        return JsonDeserializationFailure(
          message: exception.message,
          jsonPath: ex.jsonPath,
          expectedType: ex.expectedType,
          actualType: ex.actualType,
          type: ex.type,
          data: ex.data,
          details: exception.details,
        );
      case final ModelConversionException ex:
        return ModelConversionFailure(
          message: exception.message,
          sourceType: ex.sourceType,
          targetType: ex.targetType,
          type: ex.type,
          data: ex.data,
          details: exception.details,
        );
      case final HiveSerializationException ex:
        return HiveSerializationFailure(
          message: exception.message,
          typeId: ex.typeId,
          boxName: ex.boxName,
          type: ex.type,
          data: ex.data,
          details: exception.details,
        );
      case final EncodingException ex:
        return EncodingFailure(
          message: exception.message,
          encoding: ex.encoding,
          input: ex.input,
          details: exception.details,
        );
      case final DateSerializationException ex:
        return DateSerializationFailure(
          message: exception.message,
          dateFormat: ex.dateFormat,
          dateString: ex.dateString,
          type: ex.type,
          data: ex.data,
          details: exception.details,
        );
      case final EnumSerializationException ex:
        return EnumSerializationFailure(
          message: exception.message,
          enumValue: ex.enumValue,
          enumType: ex.enumType,
          type: ex.type,
          data: ex.data,
          details: exception.details,
        );

      // ============================================================
      // Device exceptions
      // ============================================================
      case final HardwareNotAvailableException ex:
        return HardwareNotAvailableFailure(
          message: exception.message,
          deviceFeature: ex.deviceFeature,
          deviceModel: ex.deviceModel,
          details: exception.details,
        );
      case final SensorException ex:
        return SensorFailure(
          message: exception.message,
          deviceFeature: ex.deviceFeature,
          deviceModel: ex.deviceModel,
          sensorDelay: ex.sensorDelay,
          details: exception.details,
        );
      case final BiometricException ex:
        return BiometricFailure(
          message: exception.message,
          deviceFeature: ex.deviceFeature,
          deviceModel: ex.deviceModel,
          biometricType: ex.biometricType,
          lockout: ex.lockout,
          details: exception.details,
        );
      case final CameraException ex:
        return CameraFailure(
          message: exception.message,
          deviceFeature: ex.deviceFeature,
          deviceModel: ex.deviceModel,
          cameraId: ex.cameraId,
          details: exception.details,
        );
      case final MicrophoneException ex:
        return MicrophoneFailure(
          message: exception.message,
          deviceFeature: ex.deviceFeature,
          deviceModel: ex.deviceModel,
          details: exception.details,
        );
      case final LocationException ex:
        return LocationFailure(
          message: exception.message,
          deviceFeature: ex.deviceFeature,
          deviceModel: ex.deviceModel,
          accuracy: ex.accuracy,
          timeout: ex.timeout,
          details: exception.details,
        );
      case final BluetoothException ex:
        return BluetoothFailure(
          message: exception.message,
          deviceFeature: ex.deviceFeature,
          deviceModel: ex.deviceModel,
          deviceAddress: ex.deviceAddress,
          deviceName: ex.deviceName,
          details: exception.details,
        );
      case final BatteryException ex:
        return BatteryFailure(
          message: exception.message,
          deviceFeature: ex.deviceFeature,
          deviceModel: ex.deviceModel,
          batteryLevel: ex.batteryLevel,
          isCharging: ex.isCharging,
          details: exception.details,
        );
      case final StorageDeviceException ex:
        return StorageDeviceFailure(
          message: exception.message,
          deviceFeature: ex.deviceFeature,
          deviceModel: ex.deviceModel,
          requiredSpace: ex.requiredSpace,
          availableSpace: ex.availableSpace,
          details: exception.details,
        );
      case final DisplayException ex:
        return DisplayFailure(
          message: exception.message,
          deviceFeature: ex.deviceFeature,
          deviceModel: ex.deviceModel,
          screenSize: ex.screenSize,
          orientation: ex.orientation,
          details: exception.details,
        );

      // ============================================================
      // Validation exceptions
      // ============================================================
      case final FormValidationException ex:
        return FormValidationFailure(
          message: exception.message,
          errors: ex.errors,
          details: exception.details,
        );

      case final DataValidationException ex:
        return DataValidationFailure(
          message: exception.message,
          field: ex.field,
          rule: ex.rule,
          value: ex.value,
          details: exception.details,
        );
      case final BusinessRuleException ex:
        return BusinessRuleFailure(
          message: exception.message,
          ruleName: ex.ruleName,
          details: exception.details,
        );
      case final DateValidationException ex:
        return DateValidationFailure(
          message: exception.message,
          dateFormat: ex.dateFormat,
          date: ex.date,
          details: exception.details,
        );
      case final RangeValidationException ex:
        return RangeValidationFailure(
          message: exception.message,
          minValue: ex.minValue,
          maxValue: ex.maxValue,
          actualValue: ex.actualValue,
          details: exception.details,
        );
      case final ValidationException ex:
        return ValidationFailure(
          message: exception.message,
          field: ex.field,
          rule: ex.rule,
          value: ex.value,
          details: exception.details,
        );
      // ============================================================
      // Permission exceptions
      // ============================================================
      case final PermissionException ex:
        return PermissionFailure(
          message: exception.message,
          permission: ex.permission,
          permanentlyDenied: ex.permanentlyDenied,
          shouldShowRationale: ex.shouldShowRationale,
          details: exception.details,
        );

      // ============================================================
      // Cache exceptions
      // ============================================================
      case final CacheException ex:
        return CacheFailure(
          message: exception.message,
          key: ex.key,
          operation: ex.operation,
          details: exception.details,
        );

      // ============================================================
      // Auth exceptions
      // ============================================================
      case final UnauthorizedAccessException ex:
        return UnauthorizedAccessFailure(
          realm: ex.realm,
          details: exception.details,
          message: exception.message,
        );
      case final InvalidCredentialsException _:
        return InvalidCredentialsFailure(      
          message: exception.message,
          details: exception.details,
        );
      case final EmailNotVerifiedException ex:
        return EmailNotVerifiedFailure(
          message: exception.message,
          resendEmail: ex.resendEmail,
          details: exception.details,
        );
      case final AccountLockedException ex:
        return AccountLockedFailure(
          remainingTime: ex.remainingTime,
          message: exception.message,
          details: exception.details,
        );
      case final AccountDisabledException _:
        return AccountDisabledFailure(message: exception.message);
      case final TwoFactorRequiredException ex:
        return TwoFactorRequiredFailure(
          twoFactorToken: ex.twoFactorToken,
          message: exception.message,
        );

      // ============================================================
      // File exceptions
      // ============================================================
      case final FileNotFoundException ex:
        return FileNotFoundFailure(
          message: exception.message,
          path: ex.path,
          fileName: ex.fileName,
          details: exception.details,
        );
      case final FileTooLargeException ex:        
        return FileTooLargeFailure(
          fileSize: ex.fileSize,
          maxSize: ex.maxSize,
          message: exception.message,
          path: ex.path,
          fileName: ex.fileName,
          details: exception.details,
        );

      // ============================================================
      // Payment exceptions
      // ============================================================
      case final PaymentDeclinedException ex:
        return PaymentDeclinedFailure(
          message: exception.message,
          declineReason: ex.declineReason,
          transactionId: ex.transactionId,
          paymentMethod: ex.paymentMethod,
          details: exception.details,
        );
      case final InsufficientFundsException ex:
        return InsufficientFundsFailure(
          message: exception.message,
          requiredAmount: ex.requiredAmount,
          availableAmount: ex.availableAmount,
          transactionId: ex.transactionId,
          paymentMethod: ex.paymentMethod,
          details: exception.details,
        );
      case final PaymentProcessingException ex:
        return PaymentProcessingFailure(
          message: exception.message,
          processingError: ex.processingError,
          transactionId: ex.transactionId,
          paymentMethod: ex.paymentMethod,
          details: exception.details,
        );
      case final PaymentTimeoutException ex:
        return PaymentTimeoutFailure(
          message: exception.message,
          transactionId: ex.transactionId,
          paymentMethod: ex.paymentMethod,
          details: exception.details,
        );
      case final RefundException ex:
        return RefundFailure(
          message: exception.message,
          transactionId: ex.transactionId,
          paymentMethod: ex.paymentMethod,
          details: exception.details,
        );
      default:
        return ServerFailure(
          message: exception.message,
          details: exception.details,
        );
    }
  }

  Failure _handleDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return ConnectionTimeoutFailure(
          message: 'Connection timeout, Please try again.',
          timeoutDuration: error.requestOptions.connectTimeout,
          endpoint: error.requestOptions.path,
          method: error.requestOptions.method,
        );
      case DioExceptionType.sendTimeout:
        return SendTimeoutFailure(
          message: 'Send timeout, Please try again.',
          timeoutDuration: error.requestOptions.sendTimeout,
          endpoint: error.requestOptions.path,
          method: error.requestOptions.method,
        );
      case DioExceptionType.receiveTimeout:
        return ReceiveTimeoutFailure(
          message: 'Receive timeout, Please try again.',
          timeoutDuration: error.requestOptions.receiveTimeout,
          endpoint: error.requestOptions.path,
          method: error.requestOptions.method,
        );
      case DioExceptionType.connectionError:
        return NoInternetConnectionFailure(
          message: 'No internet connection',
          endpoint: error.requestOptions.path,
          method: error.requestOptions.method,
        );
      case DioExceptionType.transformTimeout:
        return TransformTimeoutFailure(
          message: 'Transform timeout',
          endpoint: error.requestOptions.path,
          method: error.requestOptions.method,
        );

      case DioExceptionType.badResponse:
        return _handleStatusCode(
          error.response?.statusCode,
          error.response?.data,
          error.requestOptions.path,
          error.requestOptions.method,
        );

      case DioExceptionType.cancel:
        return RequestCancelledFailure(
          message: 'Request was cancelled, Please try again.',
          endpoint: error.requestOptions.path,
          method: error.requestOptions.method,
        );

      case DioExceptionType.badCertificate:
        return SslFailure(
          message: 'Security certificate error',
          endpoint: error.requestOptions.path,
          method: error.requestOptions.method,
        );

      case DioExceptionType.unknown:
        if (error.error is FormatException) {
          return ResponseParsingFailure(
            message: 'Invalid response format',
            rawResponse: error.response?.data,
            endpoint: error.requestOptions.path,
            method: error.requestOptions.method,
          );
        }
        if (error.error is SocketException) {
          return NoInternetConnectionFailure(
            message: 'Network error',
            endpoint: error.requestOptions.path,
            method: error.requestOptions.method,
          );
        }
        return ServerFailure(
          message: error.message ?? 'An unknown error occurred',
          endpoint: error.requestOptions.path,
        );
    }
  }

  Failure _handleStatusCode(
    int? statusCode,
    dynamic data,
    String endpoint,
    String method,
  ) {
    final message = _extractErrorMessage(data);
    final validationErrors = _extractValidationErrors(data);

    switch (statusCode) {
      case 400:
        return ValidationFailure(
          message: message ?? 'Invalid request',
          code: 'BAD_REQUEST',
          details: validationErrors,
        );
      case 401:
        return UnauthorizedRequestFailure(
          message: message ?? 'Unauthorized request',
          validationErrors: validationErrors,
          details: validationErrors,
        );
      case 403:
        return PermissionFailure(
          message: message ?? 'Access forbidden',
          permission: 'resource_access',
          details: validationErrors,
        );
      case 404:
        return NotFoundFailure(
          resourceType: 'Resource',
          message: message ?? 'Resource not found',
          details: validationErrors,
        );
      case 409:
        return AlreadyExistsFailure(
          resourceType: 'Resource',
          message: message ?? 'Conflict with current state',
          details: validationErrors,
        );
      case 422:
        return FormValidationFailure(
          message: message ?? 'Validation failed',
          errors: validationErrors ?? {},
          details: validationErrors,
        );
      case 429:
        return RateLimitExceededFailure(
          message: message ?? 'Too many requests',
          retryAfterSeconds: _extractRetryAfter(data) ?? 60,
          endpoint: endpoint,
          method: method,
          details: validationErrors,
        );
      case 500:
      case 502:
      case 503:
        return ServerFailure(
          message: message ?? 'Server error',
          code: 'SERVER_ERROR',
          statusCode: statusCode,
          endpoint: endpoint,
          details: validationErrors,
        );
      default:
        return ServerFailure(
          message: message ?? 'An error occurred',
          statusCode: statusCode,
          endpoint: endpoint,
          details: validationErrors,
        );
    }
  }

  String? _extractErrorMessage(dynamic data) {
    if (data is Map) {
      final raw =
          data['message'] ??
          data['error'] ??
          data['error_message'] ??
          data['detail'] ??
          data['msg'];
      return raw?.toString();
    }
    return null;
  }

  Map<String, List<String>>? _extractValidationErrors(dynamic data) {
    if (data is Map) {
      // Handle different error formats
      if (data['errors'] is Map) {
        final errors = <String, List<String>>{};
        for (final entry in (data['errors'] as Map).entries) {
          final value = entry.value;
          if (value is List) {
            errors[entry.key.toString()] =
                value.map((e) => e.toString()).toList();
          } else if (value is String) {
            errors[entry.key.toString()] = [value];
          }
        }
        return errors;
      }

      // Handle Laravel-style errors
      if (data['errors'] is List) {
        final errors = <String, List<String>>{};
        for (final error in data['errors'] as List) {
          if (error is Map) {
            final field = error['field'] ?? error['param'];
            final message = error['message'];
            if (field != null && message != null) {
              errors.putIfAbsent(field.toString(), () => []);
              errors[field.toString()]!.add(message.toString());
            }
          }
        }
        return errors;
      }
    }
    return null;
  }

  int? _extractRetryAfter(dynamic data) {
    if (data is Map && data['retry_after'] is int) {
      return data['retry_after'] as int;
    }
    return null;
  }
}
