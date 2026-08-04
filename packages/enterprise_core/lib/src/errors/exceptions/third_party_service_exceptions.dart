import 'package:enterprise_core/src/errors/exceptions/app_exception.dart';

/// Base exception for third-party services
class ThirdPartyServiceException extends AppException {
  /// Creates a [ThirdPartyServiceException].
  const ThirdPartyServiceException({
    required super.message,
    required this.serviceName,
    super.code = 'THIRD_PARTY_ERROR',
    super.stackTrace,
    super.details,
    this.serviceError,
    super.severity = ErrorSeverity.medium,
  });

  /// Name of the third-party service
  final String serviceName;

  /// Original error from the service
  final dynamic serviceError;
}

/// Firebase service exception
class FirebaseException extends ThirdPartyServiceException {
  /// Creates a [FirebaseException].
  const FirebaseException({
    required super.message,
    required super.serviceName,
    super.stackTrace,
    super.details,
    super.serviceError,
    this.firebaseErrorCode,
  }) : super(
         code: 'FIREBASE_ERROR',
         severity: ErrorSeverity.high,
       );

  /// Firebase-specific error code
  final String? firebaseErrorCode;
}

/// Firebase authentication exception
class FirebaseAuthException extends FirebaseException {
  /// Creates a [FirebaseAuthException].
  const FirebaseAuthException({
    required super.message,
    required String firebaseErrorCode,
    super.stackTrace,
    super.details,
    super.serviceError,
  }) : super(
         serviceName: 'Firebase Auth',
         firebaseErrorCode: firebaseErrorCode,
       );
}

/// Firebase cloud messaging exception
class FirebaseMessagingException extends FirebaseException {
  /// Creates a [FirebaseMessagingException].
  const FirebaseMessagingException({
    required super.message,
    super.stackTrace,
    super.details,
    super.serviceError,
  }) : super(
         serviceName: 'Firebase Messaging',
       );
}

/// Firebase remote config exception
class FirebaseRemoteConfigException extends FirebaseException {
  /// Creates a [FirebaseRemoteConfigException].
  const FirebaseRemoteConfigException({
    required super.message,
    super.stackTrace,
    super.details,
    super.serviceError,
  }) : super(
         serviceName: 'Firebase Remote Config',
       );
}

/// Sentry service exception
class SentryException extends ThirdPartyServiceException {
  /// Creates a [SentryException].
  const SentryException({
    required super.message,
    super.stackTrace,
    super.details,
    super.serviceError,
  }) : super(
         code: 'SENTRY_ERROR',
         serviceName: 'Sentry',
         severity: ErrorSeverity.low,
       );
}

/// Location service exception
class LocationServiceException extends ThirdPartyServiceException {
  /// Creates a [LocationServiceException].
  const LocationServiceException({
    required super.message,
    super.stackTrace,
    super.details,
    super.serviceError,
    this.locationErrorCode,
  }) : super(
         code: 'LOCATION_ERROR',
         serviceName: 'Location Service',
         severity: ErrorSeverity.medium,
       );

  /// Location-specific error code
  final int? locationErrorCode;
}

/// Notification service exception
class NotificationServiceException extends ThirdPartyServiceException {
  /// Creates a [NotificationServiceException].
  const NotificationServiceException({
    required super.message,
    super.stackTrace,
    super.details,
    super.serviceError,
  }) : super(
         code: 'NOTIFICATION_ERROR',
         serviceName: 'Notification Service',
         severity: ErrorSeverity.low,
       );
}

/// Deep link service exception
class DeepLinkServiceException extends ThirdPartyServiceException {
  /// Creates a [DeepLinkServiceException].
  const DeepLinkServiceException({
    required super.message,
    super.stackTrace,
    super.details,
    super.serviceError,
  }) : super(
         code: 'DEEP_LINK_ERROR',
         serviceName: 'Deep Link Service',
         severity: ErrorSeverity.medium,
       );
}

/// Biometric service exception
class BiometricServiceException extends ThirdPartyServiceException {
  /// Creates a [BiometricServiceException].
  const BiometricServiceException({
    required super.message,
    super.stackTrace,
    super.details,
    super.serviceError,
    this.biometricType,
  }) : super(
         code: 'BIOMETRIC_ERROR',
         serviceName: 'Biometric Service',
         severity: ErrorSeverity.medium,
       );

  /// Type of biometric authentication (Face ID, Touch ID, etc.)
  final String? biometricType;
}
