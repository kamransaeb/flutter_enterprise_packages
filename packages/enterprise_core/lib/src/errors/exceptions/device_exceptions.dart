import 'dart:ui';

import 'package:enterprise_core/src/errors/exceptions/app_exception.dart';

/// Base device exception
class DeviceException extends AppException {
  /// Creates a [DeviceException].
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
  /// Creates a [HardwareNotAvailableException].
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
  /// Creates a [SensorException].
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

  /// Creates a [SensorException].
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

  /// Creates a [SensorException].
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

  /// Sensor delay that was requested
  final int? sensorDelay;
}

/// Biometric exception
class BiometricException extends DeviceException {
  /// Creates a [BiometricException].
  const BiometricException({
    required super.message,
    super.code = 'BIOMETRIC_ERROR',
    super.stackTrace,
    super.details,
    super.deviceFeature = 'biometric',
    super.deviceModel,
    this.biometricType,
    this.lockout,
    super.severity,
  });

  /// Creates a [BiometricException].
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

  /// Creates a [BiometricException].
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

  /// Creates a [BiometricException].
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

  /// Creates a [BiometricException].
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

  /// Type of biometric (face, fingerprint, etc.)
  final String? biometricType;

  /// Whether biometric is locked out
  final bool? lockout;
}

/// Camera exception
class CameraException extends DeviceException {
  /// Creates a [CameraException].
  const CameraException({
    required super.message,
    super.code = 'CAMERA_ERROR',
    super.stackTrace,
    super.details,
    super.deviceFeature = 'camera',
    super.deviceModel,
    this.cameraId,
    super.severity,
  });

  /// Creates a [CameraException].
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

  /// Creates a [CameraException].
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

  /// Creates a [CameraException].
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

  /// Camera ID that caused the error
  final String? cameraId;
}

/// Microphone exception
class MicrophoneException extends DeviceException {
  /// Creates a [MicrophoneException].
  const MicrophoneException({
    required super.message,
    super.code = 'MICROPHONE_ERROR',
    super.stackTrace,
    super.details,
    super.deviceFeature = 'microphone',
    super.deviceModel,
    super.severity,
  });

  /// Creates a [MicrophoneException].
  factory MicrophoneException.notAvailable({
    String? message,
  }) {
    return MicrophoneException(
      message: message ?? 'Microphone not available',
      code: 'MICROPHONE_NOT_AVAILABLE',
    );
  }

  /// Creates a [MicrophoneException].
  factory MicrophoneException.permissionDenied({
    String? message,
  }) {
    return MicrophoneException(
      message: message ?? 'Microphone permission denied',
      code: 'MICROPHONE_PERMISSION_DENIED',
      severity: ErrorSeverity.high,
    );
  }

  /// Creates a [MicrophoneException].
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
  /// Creates a [LocationException].
  const LocationException({
    required super.message,
    super.code = 'LOCATION_ERROR',
    super.stackTrace,
    super.details,
    super.deviceFeature = 'location',
    super.deviceModel,
    this.accuracy,
    this.timeout,
    super.severity,
  });

  /// Creates a [LocationException].
  factory LocationException.servicesDisabled({
    String? message,
  }) {
    return LocationException(
      message: message ?? 'Location services are disabled',
      code: 'LOCATION_SERVICES_DISABLED',
      severity: ErrorSeverity.high,
    );
  }

  /// Creates a [LocationException].
  factory LocationException.permissionDenied({
    String? message,
    bool permanently = false,
  }) {
    return LocationException(
      message: message ?? 'Location permission denied',
      code: permanently
          ? 'LOCATION_PERMISSION_PERMANENTLY_DENIED'
          : 'LOCATION_PERMISSION_DENIED',
      severity: ErrorSeverity.high,
    );
  }

  /// Creates a [LocationException].
  factory LocationException.timeout({
    required Duration timeout,
    String? message,
  }) {
    return LocationException(
      message:
          message ??
          'Location request timed out after ${timeout.inSeconds} seconds',
      timeout: timeout,
      code: 'LOCATION_TIMEOUT',
    );
  }

  /// Creates a [LocationException].
  factory LocationException.unavailable({
    String? message,
  }) {
    return LocationException(
      message: message ?? 'Location is unavailable',
      code: 'LOCATION_UNAVAILABLE',
    );
  }

  /// Location accuracy requested
  final int? accuracy;

  /// Timeout duration
  final Duration? timeout;
}

/// Bluetooth exception
class BluetoothException extends DeviceException {
  /// Creates a [BluetoothException].
  const BluetoothException({
    required super.message,
    super.code = 'BLUETOOTH_ERROR',
    super.stackTrace,
    super.details,
    super.deviceFeature = 'bluetooth',
    super.deviceModel,
    this.deviceAddress,
    this.deviceName,
    super.severity,
  });

  /// Creates a [BluetoothException].
  factory BluetoothException.notAvailable({
    String? message,
  }) {
    return BluetoothException(
      message: message ?? 'Bluetooth not available',
      code: 'BLUETOOTH_NOT_AVAILABLE',
    );
  }

  /// Creates a [BluetoothException].
  factory BluetoothException.disabled({
    String? message,
  }) {
    return BluetoothException(
      message: message ?? 'Bluetooth is disabled',
      code: 'BLUETOOTH_DISABLED',
      severity: ErrorSeverity.high,
    );
  }

  /// Creates a [BluetoothException].
  factory BluetoothException.permissionDenied({
    String? message,
  }) {
    return BluetoothException(
      message: message ?? 'Bluetooth permission denied',
      code: 'BLUETOOTH_PERMISSION_DENIED',
      severity: ErrorSeverity.high,
    );
  }

  /// Creates a [BluetoothException].
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

  /// Bluetooth device address
  final String? deviceAddress;

  /// Bluetooth device name
  final String? deviceName;
}

/// Battery exception
class BatteryException extends DeviceException {
  /// Creates a [BatteryException].
  const BatteryException({
    required super.message,
    super.code = 'BATTERY_ERROR',
    super.stackTrace,
    super.details,
    super.deviceFeature = 'battery',
    super.deviceModel,
    this.batteryLevel,
    this.isCharging,
    super.severity = ErrorSeverity.low,
  });

  /// Creates a [BatteryException].
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

  /// Creates a [BatteryException].
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

  /// Current battery level (0-100)
  final int? batteryLevel;

  /// Whether device is charging
  final bool? isCharging;
}

/// Storage exception
class StorageDeviceException extends DeviceException {
  /// Creates a [StorageDeviceException].
  const StorageDeviceException({
    required super.message,
    super.code = 'STORAGE_ERROR',
    super.stackTrace,
    super.details,
    super.deviceFeature = 'storage',
    super.deviceModel,
    this.requiredSpace,
    this.availableSpace,
    super.severity = ErrorSeverity.medium,
  });

  /// Creates a [StorageDeviceException].
  factory StorageDeviceException.insufficientSpace({
    required int required,
    required int available,
    String? message,
  }) {
    return StorageDeviceException(
      message: message ??
          'Insufficient storage space. Required: '
          '${_formatSize(required)}, Available: ${_formatSize(available)}',
      requiredSpace: required,
      availableSpace: available,
      code: 'STORAGE_INSUFFICIENT_SPACE',
    );
  }

  /// Creates a [StorageDeviceException].
  factory StorageDeviceException.notMounted({
    String? message,
  }) {
    return StorageDeviceException(
      message: message ?? 'Storage not mounted',
      code: 'STORAGE_NOT_MOUNTED',
    );
  }

  /// Required storage space
  final int? requiredSpace;

  /// Available storage space
  final int? availableSpace;

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
  /// Creates a [DisplayException].
  const DisplayException({
    required super.message,
    super.code = 'DISPLAY_ERROR',
    super.stackTrace,
    super.details,
    super.deviceFeature = 'display',
    super.deviceModel,
    this.screenSize,
    this.orientation,
    super.severity = ErrorSeverity.low,
  });

  /// Creates a [DisplayException].
  factory DisplayException.unsupportedResolution({
    required Size resolution,
    String? message,
  }) {
    return DisplayException(
      message: message ??
          'Unsupported screen resolution: '
          '${resolution.width}x${resolution.height}',
      screenSize: resolution,
      code: 'DISPLAY_UNSUPPORTED_RESOLUTION',
    );
  }

  /// Creates a [DisplayException].
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

  /// Screen size in pixels
  final Size? screenSize;

  /// Screen orientation
  final String? orientation;
}
