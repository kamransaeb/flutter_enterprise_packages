import 'package:enterprise_core/src/errors/exceptions/app_exception.dart';

/// Base permission exception
class PermissionException extends AppException {
  const PermissionException({
    required super.message,
    super.code = 'PERMISSION_DENIED',
    super.stackTrace,
    super.details,
    required this.permission,
    this.permanentlyDenied = false,
    this.shouldShowRationale = true,
    super.severity = ErrorSeverity.medium,
  });

  /// Permission that was denied
  final String permission;

  /// Whether permission is permanently denied
  final bool permanentlyDenied;

  /// Whether to show rationale to user
  final bool shouldShowRationale;

  /// Check if this is a system permission
  bool get isSystemPermission => permission.startsWith('android.permission.') ||
      permission.startsWith('ios.permission.');
}

/// Camera permission exception
class CameraPermissionException extends PermissionException {
  const CameraPermissionException({
    String message = 'Camera permission is required to take photos.',
    super.stackTrace,
    super.details,
    super.permanentlyDenied,
    super.shouldShowRationale,
  }) : super(
          message: message,
          permission: 'camera',
          code: 'CAMERA_PERMISSION_DENIED',
        );
}

/// Gallery/Storage permission exception
class GalleryPermissionException extends PermissionException {
  const GalleryPermissionException({
    String message = 'Storage permission is required to access photos.',
    super.stackTrace,
    super.details,
    super.permanentlyDenied,
    super.shouldShowRationale,
  }) : super(
          message: message,
          permission: 'gallery',
          code: 'GALLERY_PERMISSION_DENIED',
        );
}

/// Location permission exception
class LocationPermissionException extends PermissionException {
  const LocationPermissionException({
    String message = 'Location permission is required for this feature.',
    super.stackTrace,
    super.details,
    super.permanentlyDenied,
    super.shouldShowRationale,
    this.locationAccuracy,
  }) : super(
          message: message,
          permission: 'location',
          code: 'LOCATION_PERMISSION_DENIED',
        );

  /// Required location accuracy
  final String? locationAccuracy;
}

/// Notification permission exception
class NotificationPermissionException extends PermissionException {
  const NotificationPermissionException({
    String message = 'Notification permission is required to receive alerts.',
    super.stackTrace,
    super.details,
    super.permanentlyDenied,
    super.shouldShowRationale,
  }) : super(
          message: message,
          permission: 'notification',
          code: 'NOTIFICATION_PERMISSION_DENIED',
        );
}

/// Microphone permission exception
class MicrophonePermissionException extends PermissionException {
  const MicrophonePermissionException({
    String message = 'Microphone permission is required for audio recording.',
    super.stackTrace,
    super.details,
    super.permanentlyDenied,
    super.shouldShowRationale,
  }) : super(
          message: message,
          permission: 'microphone',
          code: 'MICROPHONE_PERMISSION_DENIED',
        );
}

/// Contacts permission exception
class ContactsPermissionException extends PermissionException {
  const ContactsPermissionException({
    String message = 'Contacts permission is required to access your contacts.',
    super.stackTrace,
    super.details,
    super.permanentlyDenied,
    super.shouldShowRationale,
  }) : super(
          message: message,
          permission: 'contacts',
          code: 'CONTACTS_PERMISSION_DENIED',
        );
}

/// Calendar permission exception
class CalendarPermissionException extends PermissionException {
  const CalendarPermissionException({
    String message = 'Calendar permission is required to manage events.',
    super.stackTrace,
    super.details,
    super.permanentlyDenied,
    super.shouldShowRationale,
  }) : super(
          message: message,
          permission: 'calendar',
          code: 'CALENDAR_PERMISSION_DENIED',
        );
}

/// Bluetooth permission exception
class BluetoothPermissionException extends PermissionException {
  const BluetoothPermissionException({
    String message = 'Bluetooth permission is required to connect to devices.',
    super.stackTrace,
    super.details,
    super.permanentlyDenied,
    super.shouldShowRationale,
  }) : super(
          message: message,
          permission: 'bluetooth',
          code: 'BLUETOOTH_PERMISSION_DENIED',
        );
}