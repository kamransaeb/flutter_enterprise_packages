import 'dart:ui';

import 'package:equatable/equatable.dart';

/// Base failure class for the Either pattern.
///
/// Failures represent expected errors in the application domain.
/// They are used with [Either] to handle errors without exceptions.
abstract class Failure extends Equatable {
  const Failure({
    required this.message,
    this.code,
    this.details,
  });

  /// Human-readable error message
  final String message;

  /// Error code for categorization
  final String? code;

  /// Additional error context and metadata
  final Map<String, dynamic>? details;

  @override
  List<Object?> get props => [message, code, details];

  @override
  String toString() =>
      '[$runtimeType] $message${code != null ? ' (Code: $code)' : ''}';
}

// ============================================================================
// Network Failures (Low-level connectivity issues)
// ============================================================================

/// Base network failure
class NetworkFailure extends Failure {
  const NetworkFailure({
    required String message,
    super.code,
    super.details,
    this.retryable = true,
    this.timeout = false,
    this.endpoint,
    this.method,
  }) : super(message: message);

  /// Whether the operation can be retried
  final bool retryable;

  /// Whether this was a timeout error
  final bool timeout;

  /// The API endpoint that was called
  final String? endpoint;

  /// HTTP method used
  final String? method;

  @override
  List<Object?> get props => [
    ...super.props,
    retryable,
    timeout,
    endpoint,
    method,
  ];
}

/// No internet connection failure
class NoInternetConnectionFailure extends NetworkFailure {
  const NoInternetConnectionFailure({
    String message = 'No internet connection. Please check your network.',
    super.code = 'NO_INTERNET_CONNECTION',
    super.details,
    super.endpoint,
    super.method,
  }) : super(
         message: message,
         retryable: true,
         timeout: false,
       );
}

/// Transform timeout failure
class TransformTimeoutFailure extends NetworkFailure {
  const TransformTimeoutFailure({
    required String message,
    super.code = 'TRANSFORM_TIMEOUT',
    super.details,
    super.endpoint,
    super.method,
  }) : super(message: message);
}

/// Connection timeout failure
class ConnectionTimeoutFailure extends NetworkFailure {
  const ConnectionTimeoutFailure({
    String message = 'Connection timeout. Please try again.',
    super.code = 'CONNECTION_TIMEOUT',
    super.details,
    super.endpoint,
    super.method,
    this.timeoutDuration,
  }) : super(
         message: message,
         retryable: true,
         timeout: true,
       );

  /// Duration that was exceeded
  final Duration? timeoutDuration;

  @override
  List<Object?> get props => [...super.props, timeoutDuration];
}

/// Send timeout failure
class SendTimeoutFailure extends NetworkFailure {
  const SendTimeoutFailure({
    String message = 'Send timeout',
    super.code = 'SEND_TIMEOUT',
    super.details,
    super.endpoint,
    super.method,
    this.timeoutDuration,
  }) : super(
         message: message,
         retryable: true,
         timeout: true,
       );

  /// Duration that was exceeded
  final Duration? timeoutDuration;

  @override
  List<Object?> get props => [...super.props, timeoutDuration];
}

/// Receive timeout failure
class ReceiveTimeoutFailure extends NetworkFailure {
  const ReceiveTimeoutFailure({
    String message = 'Receive timeout',
    super.code = 'RECEIVE_TIMEOUT',
    super.details,
    super.endpoint,
    super.method,
    this.timeoutDuration,
  }) : super(
         message: message,
         retryable: true,
         timeout: true,
       );

  /// Duration that was exceeded
  final Duration? timeoutDuration;

  @override
  List<Object?> get props => [...super.props, timeoutDuration];
}

/// DNS resolution failure
class DnsResolutionFailure extends NetworkFailure {
  const DnsResolutionFailure({
    required String hostname,
    String message = 'Failed to resolve DNS',
    super.code = 'DNS_RESOLUTION_FAILED',
    super.details,
    super.endpoint,
    super.method,
  }) : super(
         message: '$message: $hostname',
         retryable: true,
         timeout: false,
       );
}

/// SSL/TLS certificate failure
class SslFailure extends NetworkFailure {
  const SslFailure({
    required String message,
    super.code = 'SSL_ERROR',
    super.details,
    super.endpoint,
    super.method,
    this.certificateSubject,
    this.certificateIssuer,
    this.certificateExpiryDate,
  }) : super(
         message: message,
         retryable: false,
         timeout: false,
       );

  /// Certificate subject
  final String? certificateSubject;

  /// Certificate issuer
  final String? certificateIssuer;

  /// Certificate expiry date
  final DateTime? certificateExpiryDate;

  @override
  List<Object?> get props => [
    ...super.props,
    certificateSubject,
    certificateIssuer,
    certificateExpiryDate,
  ];
}

/// Network unreachable failure
class NetworkUnreachableFailure extends NetworkFailure {
  const NetworkUnreachableFailure({
    String message = 'Network is unreachable',
    super.code = 'NETWORK_UNREACHABLE',
    super.details,
    super.endpoint,
    super.method,
  }) : super(
         message: message,
         retryable: true,
       );
}

/// Socket failure
class SocketFailure extends NetworkFailure {
  const SocketFailure({
    required String message,
    super.code = 'SOCKET_ERROR',
    super.details,
    super.endpoint,
    super.method,
    this.port,
    this.address,
  }) : super(
         message: message,
         retryable: true,
       );

  /// Port number
  final int? port;

  /// IP address
  final String? address;

  @override
  List<Object?> get props => [...super.props, port, address];
}

/// HTTP status error failure
class HttpStatusFailure extends NetworkFailure {
  const HttpStatusFailure({
    required String message,
    required this.statusCode,
    super.code = 'HTTP_STATUS_ERROR',
    super.details,
    super.endpoint,
    super.method,
    this.responseData,
  }) : super(
         message: message,
         retryable: statusCode >= 500 || statusCode == 408 || statusCode == 429,
         timeout: statusCode == 408,
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

  @override
  List<Object?> get props => [...super.props, statusCode, responseData];
}

/// Request cancelled failure
class RequestCancelledFailure extends NetworkFailure {
  const RequestCancelledFailure({
    String message = 'Request was cancelled',
    super.code = 'REQUEST_CANCELLED',
    super.details,
    super.endpoint,
    super.method,
  }) : super(
         message: message,
         retryable: false,
         timeout: false,
       );
}

/// Response parsing failure
class ResponseParsingFailure extends NetworkFailure {
  const ResponseParsingFailure({
    required String message,
    super.code = 'RESPONSE_PARSING_ERROR',
    super.details,
    super.endpoint,
    super.method,
    this.rawResponse,
    this.expectedType,
  }) : super(
         message: message,
         retryable: false,
         timeout: false,
       );

  /// Raw response that failed to parse
  final dynamic rawResponse;

  /// Expected type during parsing
  final Type? expectedType;

  @override
  List<Object?> get props => [...super.props, rawResponse, expectedType];
}

/// Rate limit exceeded failure
class RateLimitExceededFailure extends NetworkFailure {
  const RateLimitExceededFailure({
    String message = 'Rate limit exceeded',
    super.code = 'RATE_LIMIT_EXCEEDED',
    super.details,
    super.endpoint,
    super.method,
    this.retryAfterSeconds = 60,
    this.limit,
    this.remaining,
  }) : super(
         message: '$message. Retry after $retryAfterSeconds seconds',
         retryable: true,
         timeout: false,
       );

  /// Seconds to wait before retrying
  final int retryAfterSeconds;

  /// Rate limit value
  final int? limit;

  /// Remaining requests
  final int? remaining;

  @override
  List<Object?> get props => [
    ...super.props,
    retryAfterSeconds,
    limit,
    remaining,
  ];
}

/// WebSocket connection failure
class WebSocketFailure extends NetworkFailure {
  const WebSocketFailure({
    required String message,
    super.code = 'WEBSOCKET_ERROR',
    super.details,
    super.endpoint,
    this.closeCode,
    this.closeReason,
  }) : super(
         message: message,
         retryable: true,
         timeout: false,
       );

  /// WebSocket close code
  final int? closeCode;

  /// WebSocket close reason
  final String? closeReason;

  @override
  List<Object?> get props => [...super.props, closeCode, closeReason];
}

// ============================================================================
// API Failures (HTTP Status Code Related)
// ============================================================================

/// Base API failure
class ApiFailure extends Failure {
  const ApiFailure({
    required String message,
    super.code,
    super.details,
    this.statusCode,
    this.endpoint,
    this.method,
    this.responseData,
  }) : super(message: message);

  /// HTTP status code
  final int? statusCode;

  /// API endpoint that was called
  final String? endpoint;

  /// HTTP method used
  final String? method;

  /// Raw response data
  final dynamic responseData;

  /// Check if this is a client error (4xx)
  bool get isClientError =>
      statusCode != null && statusCode! >= 400 && statusCode! < 500;

  /// Check if this is a server error (5xx)
  bool get isServerError =>
      statusCode != null && statusCode! >= 500 && statusCode! < 600;

  /// Check if request can be retried
  bool get isRetryable =>
      isServerError || statusCode == 408 || statusCode == 429;

  @override
  List<Object?> get props => [...super.props, statusCode, endpoint, method];
}

/// Bad request failure (400)
class BadRequestFailure extends ApiFailure {
  const BadRequestFailure({
    required String message,
    super.statusCode = 400,
    super.code = 'BAD_REQUEST',
    super.details,
    super.endpoint,
    super.method,
    super.responseData,
    this.validationErrors,
  }) : super(message: message);

  /// Field-specific validation errors
  final Map<String, List<String>>? validationErrors;

  @override
  List<Object?> get props => [...super.props, validationErrors];
}

/// Unauthorized failure (401)
class UnauthorizedRequestFailure extends ApiFailure {
  const UnauthorizedRequestFailure({
    String message = 'Your session has expired. Please login again.',
    super.statusCode = 401,
    super.code = 'UNAUTHORIZED_REQUEST',
    super.details,
    super.endpoint,
    super.method,
    super.responseData,
    this.validationErrors,
  }) : super(message: message);

  /// Field-specific validation errors
  final Map<String, List<String>>? validationErrors;
  @override
  List<Object?> get props => [...super.props, validationErrors];
}

/// Forbidden failure (403)
class ForbiddenFailure extends ApiFailure {
  const ForbiddenFailure({
    String message = 'You don\'t have permission to access this resource.',
    super.statusCode = 403,
    super.code = 'FORBIDDEN',
    super.details,
    super.endpoint,
    super.method,
    super.responseData,
    this.requiredPermission,
  }) : super(message: message);

  /// Required permission that was missing
  final String? requiredPermission;

  @override
  List<Object?> get props => [...super.props, requiredPermission];
}

/// Not found failure (404)
class ResourceNotFoundFailure extends ApiFailure {
  const ResourceNotFoundFailure({
    String message = 'Resource not found.',
    super.statusCode = 404,
    super.code = 'RESOURCE_NOT_FOUND',
    super.details,
    super.endpoint,
    super.method,
    super.responseData,
    this.resourceType,
    this.resourceId,
  }) : super(message: message);

  /// Type of resource that wasn't found
  final String? resourceType;

  /// ID of resource that wasn't found
  final String? resourceId;

  @override
  List<Object?> get props => [...super.props, resourceType, resourceId];
}

/// Conflict failure (409)
class ConflictFailure extends ApiFailure {
  const ConflictFailure({
    required String message,
    super.statusCode = 409,
    super.code = 'CONFLICT',
    super.details,
    super.endpoint,
    super.method,
    super.responseData,
    this.conflictingField,
    this.conflictingValue,
  }) : super(message: message);

  /// Field that caused the conflict
  final String? conflictingField;

  /// Value that caused the conflict
  final String? conflictingValue;

  @override
  List<Object?> get props => [
    ...super.props,
    conflictingField,
    conflictingValue,
  ];
}

/// Unprocessable entity failure (422)
class UnprocessableEntityFailure extends ApiFailure {
  const UnprocessableEntityFailure({
    required String message,
    super.statusCode = 422,
    super.code = 'UNPROCESSABLE_ENTITY',
    super.details,
    super.endpoint,
    super.method,
    super.responseData,
    this.validationErrors,
  }) : super(message: message);

  /// Validation errors
  final Map<String, List<String>>? validationErrors;

  @override
  List<Object?> get props => [...super.props, validationErrors];
}

/// Too many requests failure (429)
class TooManyRequestsFailure extends ApiFailure {
  const TooManyRequestsFailure({
    String message = 'Too many requests. Please try again later.',
    super.statusCode = 429,
    super.code = 'TOO_MANY_REQUESTS',
    super.details,
    super.endpoint,
    super.method,
    super.responseData,
    this.limit,
    this.remaining,
    this.reset,
  }) : super(message: message);

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
  List<Object?> get props => [...super.props, limit, remaining, reset];
}

/// Internal server error failure (500)
class InternalServerErrorFailure extends ApiFailure {
  const InternalServerErrorFailure({
    String message = 'Internal server error. Please try again later.',
    super.statusCode = 500,
    super.code = 'INTERNAL_SERVER_ERROR',
    super.details,
    super.endpoint,
    super.method,
    super.responseData,
    this.errorId,
  }) : super(message: message);

  /// Error tracking ID
  final String? errorId;

  @override
  List<Object?> get props => [...super.props, errorId];
}

/// Service unavailable failure (503)
class ServiceUnavailableFailure extends ApiFailure {
  const ServiceUnavailableFailure({
    String message = 'Service temporarily unavailable. Please try again later.',
    super.statusCode = 503,
    super.code = 'SERVICE_UNAVAILABLE',
    super.details,
    super.endpoint,
    super.method,
    super.responseData,
    this.retryAfterSeconds = 60,
  }) : super(message: message);

  /// Seconds to wait before retrying
  final int retryAfterSeconds;

  @override
  List<Object?> get props => [...super.props, retryAfterSeconds];
}

// ============================================================================
// Serialization Failures
// ============================================================================

/// Base serialization failure
class SerializationFailure extends Failure {
  const SerializationFailure({
    required String message,
    super.code = 'SERIALIZATION_ERROR',
    super.details,
    this.type,
    this.data,
  }) : super(message: message);

  /// The type being serialized/deserialized
  final Type? type;

  /// The raw data that caused the error
  final dynamic data;

  @override
  List<Object?> get props => [...super.props, type, data];
}

/// JSON serialization failure
class JsonSerializationFailure extends SerializationFailure {
  const JsonSerializationFailure({
    required String message,
    super.type,
    super.data,
    super.details,
    this.jsonPath,
    this.expectedType,
    this.actualType,
  }) : super(
         message: message,
         code: 'JSON_SERIALIZATION_ERROR',
       );

  /// Path in JSON where error occurred
  final String? jsonPath;

  /// Expected type at path
  final Type? expectedType;

  /// Actual type found
  final Type? actualType;

  @override
  List<Object?> get props => [
    ...super.props,
    jsonPath,
    expectedType,
    actualType,
  ];
}

/// JSON deserialization failure
class JsonDeserializationFailure extends SerializationFailure {
  const JsonDeserializationFailure({
    required String message,
    super.type,
    super.data,
    super.details,
    this.jsonPath,
    this.expectedType,
    this.actualType,
  }) : super(
         message: message,
         code: 'JSON_DESERIALIZATION_ERROR',
       );

  /// Path in JSON where error occurred
  final String? jsonPath;

  /// Expected type at path
  final Type? expectedType;

  /// Actual type found
  final Type? actualType;

  @override
  List<Object?> get props => [
    ...super.props,
    jsonPath,
    expectedType,
    actualType,
  ];
}

/// Model conversion failure
class ModelConversionFailure extends SerializationFailure {
  const ModelConversionFailure({
    required String message,
    super.type,
    super.data,
    super.details,
    this.sourceType,
    this.targetType,
  }) : super(
         message: message,
         code: 'MODEL_CONVERSION_ERROR',
       );

  /// Source model type
  final Type? sourceType;

  /// Target model type
  final Type? targetType;

  @override
  List<Object?> get props => [...super.props, sourceType, targetType];
}

/// Hive serialization failure
class HiveSerializationFailure extends SerializationFailure {
  const HiveSerializationFailure({
    required String message,
    super.type,
    super.data,
    super.details,
    this.typeId,
    this.boxName,
  }) : super(
         message: message,
         code: 'HIVE_SERIALIZATION_ERROR',
       );

  /// Hive type ID
  final int? typeId;

  /// Hive box name
  final String? boxName;

  @override
  List<Object?> get props => [...super.props, typeId, boxName];
}

/// Encoding/Decoding failure
class EncodingFailure extends SerializationFailure {
  const EncodingFailure({
    required String message,
    super.code = 'ENCODING_ERROR',
    super.details,
    this.encoding,
    this.input,
  }) : super(message: message);

  /// Encoding type (UTF-8, Base64, etc.)
  final String? encoding;

  /// Input that failed to encode/decode
  final dynamic input;

  @override
  List<Object?> get props => [...super.props, encoding, input];
}

/// Date serialization failure
class DateSerializationFailure extends SerializationFailure {
  const DateSerializationFailure({
    required String message,
    super.type,
    super.data,
    super.details,
    this.dateFormat,
    this.dateString,
  }) : super(
         message: message,
         code: 'DATE_SERIALIZATION_ERROR',
       );

  /// Expected date format
  final String? dateFormat;

  /// Date string that failed to parse
  final String? dateString;

  @override
  List<Object?> get props => [...super.props, dateFormat, dateString];
}

/// Enum serialization failure
class EnumSerializationFailure extends SerializationFailure {
  const EnumSerializationFailure({
    required String message,
    super.type,
    super.data,
    super.details,
    this.enumValue,
    this.enumType,
  }) : super(
         message: message,
         code: 'ENUM_SERIALIZATION_ERROR',
       );

  /// Value that failed to map to enum
  final String? enumValue;

  /// Enum type
  final Type? enumType;

  @override
  List<Object?> get props => [...super.props, enumValue, enumType];
}

// ============================================================================
// Device Failures
// ============================================================================

/// Base device failure
class DeviceFailure extends Failure {
  const DeviceFailure({
    required String message,
    super.code = 'DEVICE_ERROR',
    super.details,
    this.deviceFeature,
    this.deviceModel,
  }) : super(message: message);

  /// The device feature that caused the error
  final String? deviceFeature;

  /// Device model information
  final String? deviceModel;

  @override
  List<Object?> get props => [...super.props, deviceFeature, deviceModel];
}

/// Hardware not available failure
class HardwareNotAvailableFailure extends DeviceFailure {
  const HardwareNotAvailableFailure({
    required String message,
    super.code = 'HARDWARE_NOT_AVAILABLE',
    super.details,
    super.deviceFeature,
    super.deviceModel,
  }) : super(message: message);
}

/// Sensor failure
class SensorFailure extends DeviceFailure {
  const SensorFailure({
    required String message,
    super.code = 'SENSOR_ERROR',
    super.details,
    super.deviceFeature,
    super.deviceModel,
    this.sensorDelay,
  }) : super(message: message);

  /// Sensor delay that was requested
  final int? sensorDelay;

  @override
  List<Object?> get props => [...super.props, sensorDelay];
}

/// Biometric failure
class BiometricFailure extends DeviceFailure {
  const BiometricFailure({
    required String message,
    super.code = 'BIOMETRIC_ERROR',
    super.details,
    super.deviceFeature = 'biometric',
    super.deviceModel,
    this.biometricType,
    this.lockout,
  }) : super(message: message);

  /// Type of biometric (face, fingerprint, etc.)
  final String? biometricType;

  /// Whether biometric is locked out
  final bool? lockout;

  @override
  List<Object?> get props => [...super.props, biometricType, lockout];
}

/// Camera failure
class CameraFailure extends DeviceFailure {
  const CameraFailure({
    required String message,
    super.code = 'CAMERA_ERROR',
    super.details,
    super.deviceFeature = 'camera',
    super.deviceModel,
    this.cameraId,
  }) : super(message: message);

  /// Camera ID that caused the error
  final String? cameraId;

  @override
  List<Object?> get props => [...super.props, cameraId];
}

/// Microphone failure
class MicrophoneFailure extends DeviceFailure {
  const MicrophoneFailure({
    required String message,
    super.code = 'MICROPHONE_ERROR',
    super.details,
    super.deviceFeature = 'microphone',
    super.deviceModel,
  }) : super(message: message);
}

/// Location services failure
class LocationFailure extends DeviceFailure {
  const LocationFailure({
    required String message,
    super.code = 'LOCATION_ERROR',
    super.details,
    super.deviceFeature = 'location',
    super.deviceModel,
    this.accuracy,
    this.timeout,
  }) : super(message: message);

  /// Location accuracy requested
  final int? accuracy;

  /// Timeout duration
  final Duration? timeout;

  @override
  List<Object?> get props => [...super.props, accuracy, timeout];
}

/// Bluetooth failure
class BluetoothFailure extends DeviceFailure {
  const BluetoothFailure({
    required String message,
    super.code = 'BLUETOOTH_ERROR',
    super.details,
    super.deviceFeature = 'bluetooth',
    super.deviceModel,
    this.deviceAddress,
    this.deviceName,
  }) : super(message: message);

  /// Bluetooth device address
  final String? deviceAddress;

  /// Bluetooth device name
  final String? deviceName;

  @override
  List<Object?> get props => [...super.props, deviceAddress, deviceName];
}

/// Battery failure
class BatteryFailure extends DeviceFailure {
  const BatteryFailure({
    required String message,
    super.code = 'BATTERY_ERROR',
    super.details,
    super.deviceFeature = 'battery',
    super.deviceModel,
    this.batteryLevel,
    this.isCharging,
  }) : super(message: message);

  /// Current battery level (0-100)
  final int? batteryLevel;

  /// Whether device is charging
  final bool? isCharging;

  @override
  List<Object?> get props => [...super.props, batteryLevel, isCharging];
}

/// Storage device failure
class StorageDeviceFailure extends DeviceFailure {
  const StorageDeviceFailure({
    required String message,
    super.code = 'STORAGE_ERROR',
    super.details,
    super.deviceFeature = 'storage',
    super.deviceModel,
    this.requiredSpace,
    this.availableSpace,
  }) : super(message: message);

  /// Required storage space
  final int? requiredSpace;

  /// Available storage space
  final int? availableSpace;

  @override
  List<Object?> get props => [...super.props, requiredSpace, availableSpace];
}

/// Display failure
class DisplayFailure extends DeviceFailure {
  const DisplayFailure({
    required String message,
    super.code = 'DISPLAY_ERROR',
    super.details,
    super.deviceFeature = 'display',
    super.deviceModel,
    this.screenSize,
    this.orientation,
  }) : super(message: message);

  /// Screen size in pixels
  final Size? screenSize;

  /// Screen orientation
  final String? orientation;

  @override
  List<Object?> get props => [...super.props, screenSize, orientation];
}

// ============================================================================
// Server Failures
// ============================================================================

/// Server-related failures (API calls, backend errors)
class ServerFailure extends Failure {
  const ServerFailure({
    required String message,
    super.code,
    super.details,
    this.statusCode,
    this.retryable = true,
    this.endpoint,
  }) : super(message: message);

  /// HTTP status code if applicable
  final int? statusCode;

  /// Whether the operation can be retried
  final bool retryable;

  /// The API endpoint that was called
  final String? endpoint;

  /// Check if this is a client error (4xx)
  bool get isClientError =>
      statusCode != null && statusCode! >= 400 && statusCode! < 500;

  /// Check if this is a server error (5xx)
  bool get isServerError =>
      statusCode != null && statusCode! >= 500 && statusCode! < 600;

  /// Check if this is a timeout
  bool get isTimeout => statusCode == 408 || statusCode == 504;

  /// Check if this is a rate limit error
  bool get isRateLimited => statusCode == 429;

  @override
  List<Object?> get props => [...super.props, statusCode, retryable, endpoint];
}

// ============================================================================
// Authentication Failures
// ============================================================================

/// Base authentication failure
class AuthFailure extends Failure {
  const AuthFailure({
    required String message,
    super.code,
    super.details,
    this.requiresReauth = false,
    this.requiresVerification = false,
  }) : super(message: message);

  /// Whether user needs to re-authenticate
  final bool requiresReauth;

  /// Whether user needs to verify their email
  final bool requiresVerification;

  @override
  List<Object?> get props => [
    ...super.props,
    requiresReauth,
    requiresVerification,
  ];
}

/// Unauthorized access (session expired)
class UnauthorizedAccessFailure extends AuthFailure {
  const UnauthorizedAccessFailure({
    this.realm,
    String message = 'Your session has expired. Please login again.',
    super.code = 'UNAUTHORIZED_ACCESS',
    super.details,
  }) : super(
         message: message,
         requiresReauth: true,
       );

  /// Authentication realm
  final String? realm;

  @override
  List<Object?> get props => [...super.props, realm];
}

/// Invalid credentials (wrong email/password)
class InvalidCredentialsFailure extends AuthFailure {
  const InvalidCredentialsFailure({
    String message = 'Invalid email or password.',
    super.code = 'INVALID_CREDENTIALS',
    super.details,
  }) : super(message: message);
}

/// Email not verified
class EmailNotVerifiedFailure extends AuthFailure {
  const EmailNotVerifiedFailure({
    String message = 'Please verify your email address before logging in.',
    super.code = 'EMAIL_NOT_VERIFIED',
    super.details,
    this.resendEmail = true,
  }) : super(
         message: message,
         requiresVerification: true,
       );

  /// Whether user can request a new verification email
  final bool resendEmail;

  @override
  List<Object?> get props => [...super.props, resendEmail];
}

/// Account locked due to too many attempts
class AccountLockedFailure extends AuthFailure {
  AccountLockedFailure({
    required this.remainingTime,
    String message =
        'Account temporarily locked due to too many failed attempts.',
    super.code = 'ACCOUNT_LOCKED',
    super.details,
  }) : super(
         message: '$message Try again in ${remainingTime.inMinutes} minutes.',
       );

  /// Time remaining until account is unlocked
  final Duration remainingTime;

  @override
  List<Object?> get props => [...super.props, remainingTime];
}

/// Account disabled
class AccountDisabledFailure extends AuthFailure {
  const AccountDisabledFailure({
    String message = 'Your account has been disabled. Please contact support.',
    super.code = 'ACCOUNT_DISABLED',
    super.details,
  }) : super(message: message);
}

/// Two-factor authentication required
class TwoFactorRequiredFailure extends AuthFailure {
  const TwoFactorRequiredFailure({
    required this.twoFactorToken,
    String message = 'Two-factor authentication required.',
    super.code = '2FA_REQUIRED',
    super.details,
  }) : super(message: message);

  /// Token for 2FA verification
  final String twoFactorToken;

  @override
  List<Object?> get props => [...super.props, twoFactorToken];
}

// ============================================================================
// Validation Failures
// ============================================================================

/// Validation failure for a specific field
class ValidationFailure extends Failure {
  const ValidationFailure({
    required String message,
    super.code = 'VALIDATION_ERROR',
    super.details,
    this.field,
    this.rule,
    this.value,
  }) : super(message: message);

  /// Field that failed validation
  final String? field;

  /// Validation rule that was violated
  final String? rule;

  /// Value that failed validation
  final dynamic value;

  /// Create validation failure for email
  factory ValidationFailure.email({
    required String email,
    String? message,
  }) {
    return ValidationFailure(
      message: message ?? 'Please enter a valid email address',
      field: 'email',
      rule: 'email_format',
      value: email,
      code: 'INVALID_EMAIL',
    );
  }

  /// Create validation failure for password
  factory ValidationFailure.password({
    required String password,
    required String reason,
    String? message,
  }) {
    return ValidationFailure(
      message: message ?? _getPasswordErrorMessage(reason),
      field: 'password',
      rule: 'password_$reason',
      value: password,
      code: 'INVALID_PASSWORD',
    );
  }

  /// Create validation failure for required field
  factory ValidationFailure.required({
    required String field,
    String? message,
  }) {
    return ValidationFailure(
      message: message ?? '$field is required',
      field: field,
      rule: 'required',
      code: 'FIELD_REQUIRED',
    );
  }

  /// Create validation failure for minimum length
  factory ValidationFailure.minLength({
    required String field,
    required int minLength,
    String? message,
  }) {
    return ValidationFailure(
      message: message ?? '$field must be at least $minLength characters',
      field: field,
      rule: 'min_length',
      details: {'minLength': minLength},
    );
  }

  /// Create validation failure for maximum length
  factory ValidationFailure.maxLength({
    required String field,
    required int maxLength,
    String? message,
  }) {
    return ValidationFailure(
      message: message ?? '$field cannot exceed $maxLength characters',
      field: field,
      rule: 'max_length',
      details: {'maxLength': maxLength},
    );
  }

  static String _getPasswordErrorMessage(String reason) {
    switch (reason) {
      case 'too_short':
        return 'Password must be at least 8 characters';
      case 'no_uppercase':
        return 'Password must contain at least one uppercase letter';
      case 'no_lowercase':
        return 'Password must contain at least one lowercase letter';
      case 'no_number':
        return 'Password must contain at least one number';
      case 'no_special':
        return 'Password must contain at least one special character';
      case 'common_password':
        return 'Password is too common. Please choose a stronger password';
      default:
        return 'Invalid password format';
    }
  }

  @override
  List<Object?> get props => [...super.props, field, rule, value];
}

/// Form validation failure (multiple fields)
class FormValidationFailure extends ValidationFailure {
  const FormValidationFailure({
    required super.message,
    super.code = 'FORM_VALIDATION_ERROR',
    super.details,
    required this.errors,
  }) : super(
         field: null,
         rule: null,
         value: null,
       );

  /// Map of field names to error messages
  final Map<String, List<String>> errors;

  /// Get all errors for a specific field
  List<String> getFieldErrors(String field) => errors[field] ?? [];

  /// Check if a field has errors
  bool hasFieldError(String field) => errors.containsKey(field);

  /// Get first error message for a field
  String? getFirstFieldError(String field) => errors[field]?.firstOrNull;

  factory FormValidationFailure.fromMap(Map<String, dynamic> errors) {
    final formattedErrors = <String, List<String>>{};
    errors.forEach((key, value) {
      if (value is List) {
        formattedErrors[key] = value.map((e) => e.toString()).toList();
      } else if (value is String) {
        formattedErrors[key] = [value];
      }
    });
    return FormValidationFailure(
      message: 'Please fix the errors in the form',
      errors: formattedErrors,
      details: errors,
    );
  }

  @override
  List<Object?> get props => [...super.props, errors];
}

class DataValidationFailure extends ValidationFailure {
  const DataValidationFailure({
    required super.message,
    super.code = 'DATA_VALIDATION_ERROR',
    super.details,
    required this.field,
    required this.rule,
    required this.value,
  }) : super(field: field, rule: rule, value: value);

  /// Field that failed validation
  final String? field;

  /// Validation rule that was violated
  final String? rule;

  /// Value that failed validation
  final dynamic value;

  @override
  List<Object?> get props => [...super.props, field, rule, value];
}

class RangeValidationFailure extends ValidationFailure {
  const RangeValidationFailure({
    required super.message,
    super.code = 'RANGE_VALIDATION_ERROR',
    super.details,
    required this.minValue,
    required this.maxValue,
    required this.actualValue,
  }) : super(field: null, rule: null, value: null);

  /// Minimum value that was violated
  final dynamic minValue;

  /// Maximum value that was violated
  final dynamic maxValue;

  /// Actual value that was violated
  final dynamic actualValue;

  @override
  List<Object?> get props => [...super.props, minValue, maxValue, actualValue];
}

class BusinessRuleFailure extends Failure {
  const BusinessRuleFailure({
    required super.message,
    super.code = 'BUSINESS_RULE_ERROR',
    super.details,
    required this.ruleName,
  });

  /// Business rule that was violated
  final String? ruleName;
  @override
  List<Object?> get props => [...super.props, ruleName];
}

class DateValidationFailure extends ValidationFailure {
  const DateValidationFailure({
    required super.message,
    super.code = 'DATE_VALIDATION_ERROR',
    super.details,
    required this.dateFormat,
    required this.date,
  }) : super(field: null, rule: null, value: null);

  /// Date that was violated
  final DateTime? date;

  /// Date format that was violated
  final String? dateFormat;
  @override
  List<Object?> get props => [...super.props, date, dateFormat];
}

// ============================================================================
// Permission Failures
// ============================================================================

/// Permission-related failures
class PermissionFailure extends Failure {
  const PermissionFailure({
    required String message,
    super.code = 'PERMISSION_DENIED',
    super.details,
    required this.permission,
    this.permanentlyDenied = false,
    this.shouldShowRationale = true,
  }) : super(message: message);

  /// Permission that was denied
  final String permission;

  /// Whether permission is permanently denied
  final bool permanentlyDenied;

  /// Whether to show rationale to user
  final bool shouldShowRationale;

  @override
  List<Object?> get props => [
    ...super.props,
    permission,
    permanentlyDenied,
    shouldShowRationale,
  ];
}

// ============================================================================
// Cache Failures
// ============================================================================

/// Cache-related failures
class CacheFailure extends Failure {
  const CacheFailure({
    required String message,
    super.code = 'CACHE_ERROR',
    super.details,
    this.key,
    this.operation,
  }) : super(message: message);

  /// Cache key being accessed
  final String? key;

  /// Operation being performed (read, write, delete)
  final String? operation;

  @override
  List<Object?> get props => [...super.props, key, operation];
}

// ============================================================================
// File Failures
// ============================================================================

/// File-related failures
class FileFailure extends Failure {
  const FileFailure({
    required String message,
    super.code = 'FILE_ERROR',
    super.details,
    this.path,
    this.fileName,
  }) : super(message: message);

  /// File path that caused the error
  final String? path;

  /// File name that caused the error
  final String? fileName;

  @override
  List<Object?> get props => [...super.props, path, fileName];
}

/// File not found failure
class FileNotFoundFailure extends FileFailure {
  const FileNotFoundFailure({
    String message = 'File not found',
    super.path,
    super.fileName,
    super.details,
  }) : super(
         message: message,
         code: 'FILE_NOT_FOUND',
       );
}

/// File too large failure
class FileTooLargeFailure extends FileFailure {
  FileTooLargeFailure({
    required this.fileSize,
    required this.maxSize,
    String message = 'File size exceeds limit',
    super.path,
    super.fileName,
    super.details,
  }) : super(
         message:
             '$message (${_formatSize(fileSize)} / ${_formatSize(maxSize)})',
         code: 'FILE_TOO_LARGE',
       );

  /// Actual file size
  final int fileSize;

  /// Maximum allowed size
  final int maxSize;

  static String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  @override
  List<Object?> get props => [...super.props, fileSize, maxSize];
}

// ============================================================================
// Payment Failures
// ============================================================================

/// Payment-related failures
class PaymentFailure extends Failure {
  const PaymentFailure({
    required String message,
    super.code = 'PAYMENT_ERROR',
    super.details,
    this.transactionId,
    this.paymentMethod,
  }) : super(message: message);

  /// Transaction identifier
  final String? transactionId;

  /// Payment method used
  final String? paymentMethod;

  @override
  List<Object?> get props => [...super.props, transactionId, paymentMethod];
}

/// Payment declined failure
class PaymentDeclinedFailure extends PaymentFailure {
  const PaymentDeclinedFailure({
    required String message,
    super.transactionId,
    super.paymentMethod,
    super.details,
    this.declineReason,
  }) : super(
         message: message,
         code: 'PAYMENT_DECLINED',
       );

  /// Reason for decline from payment processor
  final String? declineReason;

  @override
  List<Object?> get props => [...super.props, declineReason];
}

/// Insufficient funds failure
class InsufficientFundsFailure extends PaymentFailure {
  const InsufficientFundsFailure({
    String message = 'Insufficient funds for this transaction',
    super.transactionId,
    super.paymentMethod,
    super.details,
    this.requiredAmount,
    this.availableAmount,
  }) : super(
         message: message,
         code: 'INSUFFICIENT_FUNDS',
       );

  /// Amount required for transaction
  final double? requiredAmount;

  /// Amount available
  final double? availableAmount;

  @override
  List<Object?> get props => [...super.props, requiredAmount, availableAmount];
}

class PaymentProcessingFailure extends PaymentFailure {
  const PaymentProcessingFailure({
    required String message,
    super.transactionId,
    super.paymentMethod,
    super.details,
    this.processingError,
  }) : super(message: message);

  /// Processing error from payment processor
  final dynamic processingError;

  @override
  List<Object?> get props => [...super.props, processingError];
}

class PaymentTimeoutFailure extends PaymentFailure {
  const PaymentTimeoutFailure({
    required String message,
    super.transactionId,
    super.paymentMethod,
    super.details,
  }) : super(message: message);
}

class RefundFailure extends PaymentFailure {
  const RefundFailure({
    required String message,
    super.transactionId,
    super.paymentMethod,
    super.details,
  }) : super(message: message);
}

// ============================================================================
// Business Logic Failures
// ============================================================================

/// Business logic failure
class BusinessFailure extends Failure {
  const BusinessFailure({
    required String message,
    super.code = 'BUSINESS_ERROR',
    super.details,
    this.ruleName,
  }) : super(message: message);

  /// Business rule that was violated
  final String? ruleName;

  @override
  List<Object?> get props => [...super.props, ruleName];
}

/// Resource not found failure
class NotFoundFailure extends BusinessFailure {
  const NotFoundFailure({
    required String resourceType,
    String? identifier,
    String? message,
    super.details,
  }) : super(
         message:
             message ??
             '$resourceType not found${identifier != null ? ': $identifier' : ''}',
         code: 'NOT_FOUND',
         ruleName: 'resource_exists',
       );
}

/// Resource already exists failure
class AlreadyExistsFailure extends BusinessFailure {
  const AlreadyExistsFailure({
    required String resourceType,
    String? identifier,
    String? message,
    super.details,
  }) : super(
         message:
             message ??
             '$resourceType already exists${identifier != null ? ': $identifier' : ''}',
         code: 'ALREADY_EXISTS',
         ruleName: 'unique_constraint',
       );
}

/// Operation not allowed failure
class OperationNotAllowedFailure extends BusinessFailure {
  const OperationNotAllowedFailure({
    required String operation,
    String? reason,
    String? message,
    super.details,
  }) : super(
         message:
             message ??
             'Operation not allowed: $operation${reason != null ? ' ($reason)' : ''}',
         code: 'OPERATION_NOT_ALLOWED',
         ruleName: operation,
       );
}

// ============================================================================
// Third-Party Service Failures
// ============================================================================

/// Third-party service failure
class ThirdPartyServiceFailure extends Failure {
  const ThirdPartyServiceFailure({
    required String message,
    super.code = 'THIRD_PARTY_ERROR',
    super.details,
    required this.serviceName,
    this.serviceError,
  }) : super(message: message);

  /// Name of the third-party service
  final String serviceName;

  /// Original error from the service
  final dynamic serviceError;

  @override
  List<Object?> get props => [...super.props, serviceName, serviceError];
}

/// Firebase service failure
class FirebaseFailure extends ThirdPartyServiceFailure {
  const FirebaseFailure({
    required String message,
    required String serviceName,
    super.serviceError,
    super.details,
    this.firebaseErrorCode,
  }) : super(
         message: message,
         code: 'FIREBASE_ERROR',
         serviceName: serviceName,
       );

  /// Firebase-specific error code
  final String? firebaseErrorCode;

  @override
  List<Object?> get props => [...super.props, firebaseErrorCode];
}

// ============================================================================
// Unknown Failure
// ============================================================================

/// Unknown/unexpected failure
class UnknownFailure extends Failure {
  const UnknownFailure({
    String message = 'An unexpected error occurred',
    super.code = 'UNKNOWN_ERROR',
    super.details,
  }) : super(message: message);
}
