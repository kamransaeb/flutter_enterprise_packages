import 'dart:ui';

import 'package:enterprise_core/src/errors/exceptions/app_exception.dart';

/// Base device exception
class DeviceException extends AppException {
  const DeviceException({
    required super.message,
    super.code = 'DEVICE_ERROR',
    super.stackTrace,
    super.details,
    this.deviceFeature,
    this.deviceModel,
    super.severity = ErrorSeverity.medium,
  });

  /// The device feature that caused the error
  final String? deviceFeature;

  /// Device model information
  final String? deviceModel;
}

/// Hardware not available
class HardwareNotAvailableException extends DeviceException {
  const HardwareNotAvailableException({
    required String hardware,
    String message = 'Hardware not available',
    super.code = 'HARDWARE_NOT_AVAILABLE',
    super.stackTrace,
    super.details,
    super.deviceModel,
  }) : super(
          message: '$message: $hardware',
          deviceFeature: hardware,
          severity: ErrorSeverity.medium,
        );
}

/// Sensor exception
class SensorException extends DeviceException {
  const SensorException({
    required String sensor,
    required String message,
    super.code = 'SENSOR_ERROR',
    super.stackTrace,
    super.details,
    super.deviceModel,
    this.sensorDelay,
    super.severity,
  }) : super(
          message: '$sensor: $message',
          deviceFeature: sensor,
        );

  /// Sensor delay that was requested
  final int? sensorDelay;

  factory SensorException.notAvailable({
    required String sensor,
    String? message,
  }) {
    return SensorException(
      sensor: sensor,
      message: message ?? 'Sensor not available on this device',
      code: 'SENSOR_NOT_AVAILABLE',
    );
  }

  factory SensorException.permissionDenied({
    required String sensor,
    String? message,
  }) {
    return SensorException(
      sensor: sensor,
      message: message ?? 'Permission denied for sensor',
      code: 'SENSOR_PERMISSION_DENIED',
      severity: ErrorSeverity.high,
    );
  }
}

/// Biometric exception
class BiometricException extends DeviceException {
  const BiometricException({
    required String message,
    super.code = 'BIOMETRIC_ERROR',
    super.stackTrace,
    super.details,
    super.deviceFeature = 'biometric',
    super.deviceModel,
    this.biometricType,
    this.lockout,
        super.severity,

  }) : super(
          message: message,

        );

  /// Type of biometric (face, fingerprint, etc.)
  final String? biometricType;

  /// Whether biometric is locked out
  final bool? lockout;

  factory BiometricException.notAvailable({
    String? biometricType,
    String? message,
  }) {
    return BiometricException(
      message: message ?? 'Biometric authentication not available',
      biometricType: biometricType,
      code: 'BIOMETRIC_NOT_AVAILABLE',
    );
  }

  factory BiometricException.notEnrolled({
    String? biometricType,
    String? message,
  }) {
    return BiometricException(
      message: message ?? 'No biometrics enrolled on this device',
      biometricType: biometricType,
      code: 'BIOMETRIC_NOT_ENROLLED',
    );
  }

  factory BiometricException.lockedOut({
    String? biometricType,
    String? message,
  }) {
    return BiometricException(
      message: message ?? 'Biometric authentication locked out',
      biometricType: biometricType,
      lockout: true,
      code: 'BIOMETRIC_LOCKED_OUT',
      severity: ErrorSeverity.high,
    );
  }

  factory BiometricException.authenticationFailed({
    String? biometricType,
    String? message,
  }) {
    return BiometricException(
      message: message ?? 'Biometric authentication failed',
      biometricType: biometricType,
      code: 'BIOMETRIC_AUTH_FAILED',
    );
  }
}

/// Camera exception
class CameraException extends DeviceException {
  const CameraException({
    required String message,
    super.code = 'CAMERA_ERROR',
    super.stackTrace,
    super.details,
    super.deviceFeature = 'camera',
    super.deviceModel,
    this.cameraId,
        super.severity,

  }) : super(
          message: message,
        );

  /// Camera ID that caused the error
  final String? cameraId;

  factory CameraException.notAvailable({
    String? cameraId,
    String? message,
  }) {
    return CameraException(
      message: message ?? 'Camera not available',
      cameraId: cameraId,
      code: 'CAMERA_NOT_AVAILABLE',
    );
  }

  factory CameraException.inUse({
    String? cameraId,
    String? message,
  }) {
    return CameraException(
      message: message ?? 'Camera is already in use',
      cameraId: cameraId,
      code: 'CAMERA_IN_USE',
    );
  }

  factory CameraException.permissionDenied({
    String? cameraId,
    String? message,
  }) {
    return CameraException(
      message: message ?? 'Camera permission denied',
      cameraId: cameraId,
      code: 'CAMERA_PERMISSION_DENIED',
      severity: ErrorSeverity.high,
    );
  }
}

/// Microphone exception
class MicrophoneException extends DeviceException {
  const MicrophoneException({
    required String message,
    super.code = 'MICROPHONE_ERROR',
    super.stackTrace,
    super.details,
    super.deviceFeature = 'microphone',
    super.deviceModel,
        super.severity,

  }) : super(
          message: message,
        );

  factory MicrophoneException.notAvailable({
    String? message,
  }) {
    return MicrophoneException(
      message: message ?? 'Microphone not available',
      code: 'MICROPHONE_NOT_AVAILABLE',
    );
  }

  factory MicrophoneException.permissionDenied({
    String? message,
  }) {
    return MicrophoneException(
      message: message ?? 'Microphone permission denied',
      code: 'MICROPHONE_PERMISSION_DENIED',
      severity: ErrorSeverity.high,
    );
  }

  factory MicrophoneException.recordingFailed({
    String? message,
  }) {
    return MicrophoneException(
      message: message ?? 'Failed to start recording',
      code: 'MICROPHONE_RECORDING_FAILED',
    );
  }
}

/// Location services exception
class LocationException extends DeviceException {
  const LocationException({
    required String message,
    super.code = 'LOCATION_ERROR',
    super.stackTrace,
    super.details,
    super.deviceFeature = 'location',
    super.deviceModel,
    this.accuracy,
    this.timeout,
        super.severity,

  }) : super(
          message: message,
        );

  /// Location accuracy requested
  final int? accuracy;

  /// Timeout duration
  final Duration? timeout;

  factory LocationException.servicesDisabled({
    String? message,
  }) {
    return LocationException(
      message: message ?? 'Location services are disabled',
      code: 'LOCATION_SERVICES_DISABLED',
      severity: ErrorSeverity.high,
    );
  }

  factory LocationException.permissionDenied({
    String? message,
    bool permanently = false,
  }) {
    return LocationException(
      message: message ?? 'Location permission denied',
      code: permanently ? 'LOCATION_PERMISSION_PERMANENTLY_DENIED' : 'LOCATION_PERMISSION_DENIED',
      severity: ErrorSeverity.high,
    );
  }

  factory LocationException.timeout({
    required Duration timeout,
    String? message,
  }) {
    return LocationException(
      message: message ?? 'Location request timed out after ${timeout.inSeconds} seconds',
      timeout: timeout,
      code: 'LOCATION_TIMEOUT',
    );
  }

  factory LocationException.unavailable({
    String? message,
  }) {
    return LocationException(
      message: message ?? 'Location is unavailable',
      code: 'LOCATION_UNAVAILABLE',
    );
  }
}

/// Bluetooth exception
class BluetoothException extends DeviceException {
  const BluetoothException({
    required String message,
    super.code = 'BLUETOOTH_ERROR',
    super.stackTrace,
    super.details,
    super.deviceFeature = 'bluetooth',
    super.deviceModel,
    this.deviceAddress,
    this.deviceName,
        super.severity,

  }) : super(
          message: message,
        );

  /// Bluetooth device address
  final String? deviceAddress;

  /// Bluetooth device name
  final String? deviceName;

  factory BluetoothException.notAvailable({
    String? message,
  }) {
    return BluetoothException(
      message: message ?? 'Bluetooth not available',
      code: 'BLUETOOTH_NOT_AVAILABLE',
    );
  }

  factory BluetoothException.disabled({
    String? message,
  }) {
    return BluetoothException(
      message: message ?? 'Bluetooth is disabled',
      code: 'BLUETOOTH_DISABLED',
      severity: ErrorSeverity.high,
    );
  }

  factory BluetoothException.permissionDenied({
    String? message,
  }) {
    return BluetoothException(
      message: message ?? 'Bluetooth permission denied',
      code: 'BLUETOOTH_PERMISSION_DENIED',
      severity: ErrorSeverity.high,
    );
  }

  factory BluetoothException.connectionFailed({
    required String deviceName,
    String? deviceAddress,
    String? message,
  }) {
    return BluetoothException(
      message: message ?? 'Failed to connect to $deviceName',
      deviceName: deviceName,
      deviceAddress: deviceAddress,
      code: 'BLUETOOTH_CONNECTION_FAILED',
    );
  }
}

/// Battery exception
class BatteryException extends DeviceException {
  const BatteryException({
    required String message,
    super.code = 'BATTERY_ERROR',
    super.stackTrace,
    super.details,
    super.deviceFeature = 'battery',
    super.deviceModel,
    this.batteryLevel,
    this.isCharging,
        super.severity = ErrorSeverity.low,

  }) : super(
          message: message,
        );

  /// Current battery level (0-100)
  final int? batteryLevel;

  /// Whether device is charging
  final bool? isCharging;

  factory BatteryException.lowBattery({
    required int batteryLevel,
    String? message,
  }) {
    return BatteryException(
      message: message ?? 'Low battery: $batteryLevel%',
      batteryLevel: batteryLevel,
      code: 'BATTERY_LOW',
      severity: ErrorSeverity.medium,
    );
  }

  factory BatteryException.criticalBattery({
    required int batteryLevel,
    String? message,
  }) {
    return BatteryException(
      message: message ?? 'Critical battery: $batteryLevel%',
      batteryLevel: batteryLevel,
      code: 'BATTERY_CRITICAL',
      severity: ErrorSeverity.high,
    );
  }
}

/// Storage exception
class StorageDeviceException extends DeviceException {
  const StorageDeviceException({
    required String message,
    super.code = 'STORAGE_ERROR',
    super.stackTrace,
    super.details,
    super.deviceFeature = 'storage',
    super.deviceModel,
    this.requiredSpace,
    this.availableSpace,
  }) : super(
          message: message,
          severity: ErrorSeverity.medium,
        );

  /// Required storage space
  final int? requiredSpace;

  /// Available storage space
  final int? availableSpace;

  factory StorageDeviceException.insufficientSpace({
    required int required,
    required int available,
    String? message,
  }) {
    return StorageDeviceException(
      message: message ?? 'Insufficient storage space. Required: ${_formatSize(required)}, Available: ${_formatSize(available)}',
      requiredSpace: required,
      availableSpace: available,
      code: 'STORAGE_INSUFFICIENT_SPACE',
    );
  }

  factory StorageDeviceException.notMounted({
    String? message,
  }) {
    return StorageDeviceException(
      message: message ?? 'Storage not mounted',
      code: 'STORAGE_NOT_MOUNTED',
    );
  }

  static String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}

/// Screen/Display exception
class DisplayException extends DeviceException {
  const DisplayException({
    required String message,
    super.code = 'DISPLAY_ERROR',
    super.stackTrace,
    super.details,
    super.deviceFeature = 'display',
    super.deviceModel,
    this.screenSize,
    this.orientation,
  }) : super(
          message: message,
          severity: ErrorSeverity.low,
        );

  /// Screen size in pixels
  final Size? screenSize;

  /// Screen orientation
  final String? orientation;

  factory DisplayException.unsupportedResolution({
    required Size resolution,
    String? message,
  }) {
    return DisplayException(
      message: message ?? 'Unsupported screen resolution: ${resolution.width}x${resolution.height}',
      screenSize: resolution,
      code: 'DISPLAY_UNSUPPORTED_RESOLUTION',
    );
  }

  factory DisplayException.unsupportedOrientation({
    required String orientation,
    String? message,
  }) {
    return DisplayException(
      message: message ?? 'Unsupported orientation: $orientation',
      orientation: orientation,
      code: 'DISPLAY_UNSUPPORTED_ORIENTATION',
    );
  }
}