import 'package:enterprise_core/src/errors/exceptions/app_exception.dart';

/// Base exception for third-party services
class ThirdPartyServiceException extends AppException {
  const ThirdPartyServiceException({
    required super.message,
    super.code = 'THIRD_PARTY_ERROR',
    super.stackTrace,
    super.details,
    required this.serviceName,
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
  const FirebaseException({
    required String message,
    super.stackTrace,
    super.details,
    required String serviceName,
    super.serviceError,
    this.firebaseErrorCode,
  }) : super(
          message: message,
          code: 'FIREBASE_ERROR',
          serviceName: serviceName,
          severity: ErrorSeverity.high,
        );

  /// Firebase-specific error code
  final String? firebaseErrorCode;
}

/// Firebase authentication exception
class FirebaseAuthException extends FirebaseException {
  const FirebaseAuthException({
    required String message,
    required String firebaseErrorCode,
    super.stackTrace,
    super.details,
    super.serviceError,
  }) : super(
          message: message,
          serviceName: 'Firebase Auth',
          firebaseErrorCode: firebaseErrorCode,
        );
}

/// Firebase cloud messaging exception
class FirebaseMessagingException extends FirebaseException {
  const FirebaseMessagingException({
    required String message,
    super.stackTrace,
    super.details,
    super.serviceError,
  }) : super(
          message: message,
          serviceName: 'Firebase Messaging',
        );
}

/// Firebase remote config exception
class FirebaseRemoteConfigException extends FirebaseException {
  const FirebaseRemoteConfigException({
    required String message,
    super.stackTrace,
    super.details,
    super.serviceError,
  }) : super(
          message: message,
          serviceName: 'Firebase Remote Config',
        );
}

/// Sentry service exception
class SentryException extends ThirdPartyServiceException {
  const SentryException({
    required String message,
    super.stackTrace,
    super.details,
    super.serviceError,
  }) : super(
          message: message,
          code: 'SENTRY_ERROR',
          serviceName: 'Sentry',
          severity: ErrorSeverity.low,
        );
}

/// Location service exception
class LocationServiceException extends ThirdPartyServiceException {
  const LocationServiceException({
    required String message,
    super.stackTrace,
    super.details,
    super.serviceError,
    this.locationErrorCode,
  }) : super(
          message: message,
          code: 'LOCATION_ERROR',
          serviceName: 'Location Service',
          severity: ErrorSeverity.medium,
        );

  /// Location-specific error code
  final int? locationErrorCode;
}

/// Notification service exception
class NotificationServiceException extends ThirdPartyServiceException {
  const NotificationServiceException({
    required String message,
    super.stackTrace,
    super.details,
    super.serviceError,
  }) : super(
          message: message,
          code: 'NOTIFICATION_ERROR',
          serviceName: 'Notification Service',
          severity: ErrorSeverity.low,
        );
}

/// Deep link service exception
class DeepLinkServiceException extends ThirdPartyServiceException {
  const DeepLinkServiceException({
    required String message,
    super.stackTrace,
    super.details,
    super.serviceError,
  }) : super(
          message: message,
          code: 'DEEP_LINK_ERROR',
          serviceName: 'Deep Link Service',
          severity: ErrorSeverity.medium,
        );
}

/// Biometric service exception
class BiometricServiceException extends ThirdPartyServiceException {
  const BiometricServiceException({
    required String message,
    super.stackTrace,
    super.details,
    super.serviceError,
    this.biometricType,
  }) : super(
          message: message,
          code: 'BIOMETRIC_ERROR',
          serviceName: 'Biometric Service',
          severity: ErrorSeverity.medium,
        );

  /// Type of biometric authentication (Face ID, Touch ID, etc.)
  final String? biometricType;
}