import 'package:enterprise_core/src/errors/exceptions/app_exception.dart';

/// Base permission exception
class PermissionException extends AppException {
  /// Creates a [PermissionException].
  const PermissionException({
    required super.message,
    required this.permission,
    super.code = 'PERMISSION_DENIED',
    super.stackTrace,
    super.details,
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
  bool get isSystemPermission =>
      permission.startsWith('android.permission.') ||
      permission.startsWith('ios.permission.');
}

/// Camera permission exception
class CameraPermissionException extends PermissionException {
  /// Creates a [CameraPermissionException].
  const CameraPermissionException({
    super.message = 'Camera permission is required to take photos.',
    super.stackTrace,
    super.details,
    super.permanentlyDenied,
    super.shouldShowRationale,
  }) : super(
         permission: 'camera',
         code: 'CAMERA_PERMISSION_DENIED',
       );
}

/// Gallery/Storage permission exception
class GalleryPermissionException extends PermissionException {
  /// Creates a [GalleryPermissionException].
  const GalleryPermissionException({
    super.message = 'Storage permission is required to access photos.',
    super.stackTrace,
    super.details,
    super.permanentlyDenied,
    super.shouldShowRationale,
  }) : super(
         permission: 'gallery',
         code: 'GALLERY_PERMISSION_DENIED',
       );
}

/// Location permission exception
class LocationPermissionException extends PermissionException {
  /// Creates a [LocationPermissionException].
  const LocationPermissionException({
    super.message = 'Location permission is required for this feature.',
    super.stackTrace,
    super.details,
    super.permanentlyDenied,
    super.shouldShowRationale,
    this.locationAccuracy,
  }) : super(
         permission: 'location',
         code: 'LOCATION_PERMISSION_DENIED',
       );

  /// Required location accuracy
  final String? locationAccuracy;
}

/// Notification permission exception
class NotificationPermissionException extends PermissionException {
  /// Creates a [NotificationPermissionException].
  const NotificationPermissionException({
    super.message = 'Notification permission is required to receive alerts.',
    super.stackTrace,
    super.details,
    super.permanentlyDenied,
    super.shouldShowRationale,
  }) : super(
         permission: 'notification',
         code: 'NOTIFICATION_PERMISSION_DENIED',
       );
}

/// Microphone permission exception
class MicrophonePermissionException extends PermissionException {
  /// Creates a [MicrophonePermissionException].
  const MicrophonePermissionException({
    super.message = 'Microphone permission is required for audio recording.',
    super.stackTrace,
    super.details,
    super.permanentlyDenied,
    super.shouldShowRationale,
  }) : super(
         permission: 'microphone',
         code: 'MICROPHONE_PERMISSION_DENIED',
       );
}

/// Contacts permission exception
class ContactsPermissionException extends PermissionException {
  /// Creates a [ContactsPermissionException].
  const ContactsPermissionException({
    super.message =
        'Contacts permission is required to access your contacts.',
    super.stackTrace,
    super.details,
    super.permanentlyDenied,
    super.shouldShowRationale,
  }) : super(
         permission: 'contacts',
         code: 'CONTACTS_PERMISSION_DENIED',
       );
}

/// Calendar permission exception
class CalendarPermissionException extends PermissionException {
  /// Creates a [CalendarPermissionException].
  const CalendarPermissionException({
    super.message = 'Calendar permission is required to manage events.',
    super.stackTrace,
    super.details,
    super.permanentlyDenied,
    super.shouldShowRationale,
  }) : super(
         permission: 'calendar',
         code: 'CALENDAR_PERMISSION_DENIED',
       );
}

/// Bluetooth permission exception
class BluetoothPermissionException extends PermissionException {
  /// Creates a [BluetoothPermissionException].
  const BluetoothPermissionException({
    super.message =
        'Bluetooth permission is required to connect to devices.',
    super.stackTrace,
    super.details,
    super.permanentlyDenied,
    super.shouldShowRationale,
  }) : super(
         permission: 'bluetooth',
         code: 'BLUETOOTH_PERMISSION_DENIED',
       );
}
