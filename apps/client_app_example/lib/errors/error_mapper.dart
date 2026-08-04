import 'package:easy_localization/easy_localization.dart';
import 'package:enterprise_core/enterprise_core.dart';
import 'package:flutter/material.dart';

/// Maps failures to user-friendly messages and UI components.
///
/// This class provides a centralized way to convert technical failures
/// into user-facing messages and appropriate UI widgets.
class ErrorMapper {
  const ErrorMapper._();

  // ============================================================================
  // User Messages
  // ============================================================================

  /// Convert failure to user-friendly message
  static String toUserMessage(Failure failure) {
    // Map failure types to user messages
    switch (failure) {
      // Network failures (subtypes before NetworkFailure)
      case NoInternetConnectionFailure _:
        return 'no_internet_error'.tr();

      case ConnectionTimeoutFailure _:
        return 'connection_timeout_error'.tr();

      case DnsResolutionFailure _:
        return 'dns_resolution_error'.tr();

      case SslFailure _:
        return 'ssl_error'.tr();

      case HttpStatusFailure f:
        return _mapHttpStatusFailure(f);

      case RequestCancelledFailure _:
        return 'request_cancelled_error'.tr();

      case ResponseParsingFailure _:
        return 'response_parsing_error'.tr();

      case RateLimitExceededFailure _:
        return 'rate_limit_error'.tr();

      case WebSocketFailure _:
        return 'web_socket_error'.tr();

      case NetworkFailure f:
        return _mapNetworkFailure(f);

      // Serialization failures
      case JsonSerializationFailure f:
        return _mapJsonSerializationFailure(f);

      case ModelConversionFailure _:
        return 'data_conversion_error'.tr();

      case HiveSerializationFailure _:
        return 'storage_read_error'.tr();

      case EncodingFailure _:
        return 'encoding_error'.tr();

      case DateSerializationFailure _:
        return 'date_format_error'.tr();

      case EnumSerializationFailure _:
        return 'invalid_value_error'.tr();

      // Device failures
      case HardwareNotAvailableFailure f:
        return _mapHardwareFailure(f);

      case SensorFailure f:
        return _mapSensorFailure(f);

      case BiometricFailure f:
        return _mapBiometricFailure(f);

      case CameraFailure f:
        return _mapCameraFailure(f);

      case MicrophoneFailure f:
        return _mapMicrophoneFailure(f);

      case LocationFailure f:
        return _mapLocationFailure(f);

      case BluetoothFailure f:
        return _mapBluetoothFailure(f);

      case BatteryFailure f:
        return _mapBatteryFailure(f);

      case StorageDeviceFailure f:
        return _mapStorageFailure(f);

      case DisplayFailure f:
        return _mapDisplayFailure(f);

      // Server failures
      case ServerFailure f:
        return _mapServerFailure(f);

      // Authentication failures
      case UnauthorizedAccessFailure _:
        return 'unauthorized_error'.tr();

      case InvalidCredentialsFailure _:
        return 'invalid_credentials_error'.tr();

      case EmailNotVerifiedFailure _:
        return 'email_not_verified_error'.tr();

      case AccountLockedFailure f:
        return 'account_locked_error'.tr(
          args: [f.remainingTime.inMinutes.toString()],
        );

      case AccountDisabledFailure _:
        return 'account_disabled_error'.tr();

      // Validation failures (subtype before ValidationFailure)
      case FormValidationFailure _:
        return 'form_validation_error'.tr();

      case ValidationFailure f:
        return _mapValidationFailure(f);

      // Permission failures
      case PermissionFailure f:
        return _mapPermissionFailure(f);

      // File failures
      case FileNotFoundFailure _:
        return 'file_not_found_error'.tr();

      case FileTooLargeFailure f:
        return 'file_too_large_error'.tr(
          namedArgs: {
            'file_size': _formatSize(f.fileSize),
            'max_size': _formatSize(f.maxSize),
          },
        );

      // Payment failures
      case PaymentDeclinedFailure f:
        return f.declineReason != null
            ? 'Payment declined: ${f.declineReason}'
            : 'payment_declined_error'.tr();

      case InsufficientFundsFailure _:
        return 'insufficient_funds_error'.tr();

      // Business failures
      case NotFoundFailure _:
        return 'resource_not_found_error'.tr();

      case AlreadyExistsFailure _:
        return 'resource_already_exists_error'.tr();

      case OperationNotAllowedFailure _:
        return 'operation_not_allowed_error'.tr();

      // Third-party service failures
      case FirebaseFailure _:
        return 'service_unavailable_error'.tr();

      // Unknown failure
      default:
        return 'unknown_error'.tr();
    }
  }

  // ============================================================================
  // Network Message Mappers
  // ============================================================================

  static String _mapNetworkFailure(NetworkFailure failure) {
    if (failure.timeout) {
      return 'connection_timeout_error'.tr();
    }
    return 'network_error'.tr();
  }

  static String _mapHttpStatusFailure(HttpStatusFailure failure) {
    if (failure.isRateLimited) {
      return 'rate_limit_error'.tr();
    }
    if (failure.isAuthenticationError) {
      return 'unauthorized_error'.tr();
    }
    if (failure.isPermissionError) {
      return 'permission_denied_error'.tr();
    }
    if (failure.isNotFound) {
      return 'resource_not_found_error'.tr();
    }
    if (failure.isServerError) {
      return 'server_error'.tr();
    }
    return failure.message;
  }

  // ============================================================================
  // Serialization Message Mappers
  // ============================================================================

  static String _mapJsonSerializationFailure(JsonSerializationFailure failure) {
    if (failure.jsonPath != null) {
      return 'invalid_data_at_path_error'.tr(args: [failure.jsonPath!]);
    }
    return 'invalid_data_error'.tr();
  }

  // ============================================================================
  // Device Message Mappers
  // ============================================================================

  static String _mapHardwareFailure(HardwareNotAvailableFailure failure) {
    final hardware = failure.deviceFeature ?? 'hardware';
    return 'hardware_not_available_error'.tr(args: [hardware]);
  }

  static String _mapSensorFailure(SensorFailure failure) {
    if (failure.code == 'SENSOR_NOT_AVAILABLE') {
      return 'sensor_not_available_error'.tr(
        args: [failure.deviceFeature ?? 'Sensor'],
      );
    }
    if (failure.code == 'SENSOR_PERMISSION_DENIED') {
      return 'sensor_permission_error'.tr(
        args: [failure.deviceFeature ?? 'Sensor'],
      );
    }
    return failure.message;
  }

  static String _mapBiometricFailure(BiometricFailure failure) {
    switch (failure.code) {
      case 'BIOMETRIC_NOT_AVAILABLE':
        return 'biometric_not_available_error'.tr();
      case 'BIOMETRIC_NOT_ENROLLED':
        return 'biometric_not_enrolled_error'.tr();
      case 'BIOMETRIC_LOCKED_OUT':
        return 'biometric_locked_out_error'.tr();
      case 'BIOMETRIC_AUTH_FAILED':
        return 'biometric_auth_failed_error'.tr();
      default:
        return failure.message;
    }
  }

  static String _mapCameraFailure(CameraFailure failure) {
    switch (failure.code) {
      case 'CAMERA_NOT_AVAILABLE':
        return 'camera_not_available_error'.tr();
      case 'CAMERA_IN_USE':
        return 'camera_in_use_error'.tr();
      case 'CAMERA_PERMISSION_DENIED':
        return 'camera_permission_error'.tr();
      default:
        return failure.message;
    }
  }

  static String _mapMicrophoneFailure(MicrophoneFailure failure) {
    switch (failure.code) {
      case 'MICROPHONE_NOT_AVAILABLE':
        return 'microphone_not_available_error'.tr();
      case 'MICROPHONE_PERMISSION_DENIED':
        return 'microphone_permission_error'.tr();
      case 'MICROPHONE_RECORDING_FAILED':
        return 'recording_failed_error'.tr();
      default:
        return failure.message;
    }
  }

  static String _mapLocationFailure(LocationFailure failure) {
    switch (failure.code) {
      case 'LOCATION_SERVICES_DISABLED':
        return 'location_services_disabled_error'.tr();  
      case 'LOCATION_PERMISSION_DENIED':
        return 'location_permission_error'.tr();
      case 'LOCATION_PERMISSION_PERMANENTLY_DENIED':
        return 'location_permission_permanently_denied_error'.tr();
      case 'LOCATION_TIMEOUT':
        return 'location_timeout_error'.tr();
      case 'LOCATION_UNAVAILABLE':
        return 'location_unavailable_error'.tr();
      default:
        return failure.message;
    }
  }

  static String _mapBluetoothFailure(BluetoothFailure failure) {
    switch (failure.code) {
      case 'BLUETOOTH_NOT_AVAILABLE':
        return 'bluetooth_not_available_error'.tr();
      case 'BLUETOOTH_DISABLED':
        return 'bluetooth_disabled_error'.tr();
      case 'BLUETOOTH_PERMISSION_DENIED':
        return 'bluetooth_permission_error'.tr();
      case 'BLUETOOTH_CONNECTION_FAILED':
        return 'bluetooth_connection_error'.tr(
          args: [failure.deviceName ?? 'Device'],
        );
      default:
        return failure.message;
    }
  }

  static String _mapBatteryFailure(BatteryFailure failure) {
    if (failure.batteryLevel != null) {
      if (failure.batteryLevel! <= 15) {
        return 'critical_battery_error'.tr(args: [failure.batteryLevel!.toString()]);
      }
      if (failure.batteryLevel! <= 20) {
        return 'low_battery_error'.tr(args: [failure.batteryLevel!.toString()]);
      }
    }
    return failure.message;
  }

  static String _mapStorageFailure(StorageDeviceFailure failure) {
    if (failure.requiredSpace != null && failure.availableSpace != null) {
      return 'insufficient_storage_error'.tr(
        args: [
          _formatSize(failure.requiredSpace!),
          _formatSize(failure.availableSpace!),
        ],
      );
    }
    return 'storage_error'.tr();
  }

  static String _mapDisplayFailure(DisplayFailure failure) {
    return 'unsupported_display_error'.tr();
  }

  static String _mapServerFailure(ServerFailure failure) {
    if (failure.isRateLimited) {
      return 'rate_limit_error'.tr();
    }
    if (failure.isTimeout) {
      return 'timeout_error'.tr();
    }
    if (failure.isClientError) {
      return 'client_error'.tr();
    }
    if (failure.isServerError) {
      return 'server_error'.tr();
    }
    return failure.message;
  }

  static String _mapValidationFailure(ValidationFailure failure) {
    if (failure.field != null && failure.rule != null) {
      return 'field_validation_error'.tr(args: [failure.field!, failure.message]);
    }
    return failure.message;
  }

  static String _mapPermissionFailure(PermissionFailure failure) {
    if (failure.permanentlyDenied) {
      return 'permission_permanently_denied'.tr(args: [failure.permission]);
    }
    return 'permission_required'.tr(args: [failure.permission]);
  }

  static String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  // ============================================================================
  // SnackBar
  // ============================================================================

  /// Convert failure to a SnackBar
  static SnackBar toSnackBar(
    Failure failure, {
    Duration duration = const Duration(seconds: 4),
    SnackBarBehavior behavior = SnackBarBehavior.floating,
    VoidCallback? onDismiss,
  }) {
    final message = toUserMessage(failure);

    return SnackBar(
      content: Text(message),
      backgroundColor: _getSnackBarColor(failure),
      duration: duration,
      behavior: behavior,
      action: _getSnackBarAction(failure, onDismiss),
      onVisible: () {
        _trackErrorShown(failure, 'snackbar');
      },
    );
  }

  static Color _getSnackBarColor(Failure failure) {
    switch (failure) {
      case NetworkFailure _:
        return Colors.orange;

      case UnauthorizedAccessFailure _:
      case InvalidCredentialsFailure _:
      case AccountLockedFailure _:
        return Colors.red;

      case ValidationFailure _:
      case JsonSerializationFailure _:
      case DateSerializationFailure _:
        return Colors.amber;

      case PermissionFailure _:
      case CameraFailure _:
      case MicrophoneFailure _:
      case LocationFailure _:
      case BluetoothFailure _:
        return Colors.blue;

      case BatteryFailure _:
        return Colors.yellow.shade800;

      case StorageDeviceFailure _:
        return Colors.purple;

      default:
        return Colors.red;
    }
  }

  static SnackBarAction? _getSnackBarAction(
    Failure failure,
    VoidCallback? onDismiss,
  ) {
    if (_isRetryable(failure)) {
      return SnackBarAction(
        label: 'Retry',
        onPressed: () {
          _trackErrorAction(failure, 'retry');
          onDismiss?.call();
        },
      );
    }
    return null;
  }

  // ============================================================================
  // Dialogs
  // ============================================================================

  /// Show error dialog for failure
  static Future<void> showErrorDialog({
    required BuildContext context,
    required Failure failure,
    VoidCallback? onRetry,
    VoidCallback? onDismiss,
    String? title,
    bool barrierDismissible = false,
  }) async {
    final message = toUserMessage(failure);
    final isRetryable = _isRetryable(failure);

    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (dialogContext) => AlertDialog(
        title: Row(
          children: [
            Icon(_getDialogIcon(failure), color: _getDialogIconColor(failure)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title ?? _getDialogTitle(failure),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message),
            if (_shouldShowDetails(failure))
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _getErrorDetails(failure),
                  style: Theme.of(
                    dialogContext,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                ),
              ),
            if (_shouldShowActionTip(failure))
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: _getActionTip(failure),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              _trackErrorAction(failure, 'dismiss');
              onDismiss?.call();
            },
            child: Text('cancel'.tr()),
          ),
          if (isRetryable)
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                _trackErrorAction(failure, 'retry');
                onRetry?.call();
              },
              child: Text('retry'.tr()),
            ),
          if (_shouldShowSettingsAction(failure))
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                _trackErrorAction(failure, 'open_settings');
                _openAppSettings(failure);
              },
              child: Text('open_settings'.tr()),
            ),
        ],
      ),
    );
  }

  static IconData _getDialogIcon(Failure failure) {
    switch (failure) {
      case ConnectionTimeoutFailure _:
        return Icons.timer_off;
      case NetworkFailure _:
        return Icons.wifi_off;
      case UnauthorizedRequestFailure _:
        return Icons.lock;
      case ValidationFailure _:
        return Icons.error_outline;
      case PermissionFailure _:
      case CameraFailure _:
      case MicrophoneFailure _:
      case LocationFailure _:
        return Icons.security;
      case BatteryFailure _:
        return Icons.battery_alert;
      case StorageDeviceFailure _:
        return Icons.storage;
      case BiometricFailure _:
        return Icons.fingerprint;
      default:
        return Icons.error_outline;
    }
  }

  static Color _getDialogIconColor(Failure failure) {
    switch (failure) {
      case BatteryFailure _:
        return Colors.orange;
      case StorageDeviceFailure _:
        return Colors.purple;
      default:
        return Colors.red;
    }
  }

  static String _getDialogTitle(Failure failure) {
    switch (failure) {
      case BatteryFailure _:
        return 'battery_alert_title'.tr();
      case StorageDeviceFailure _:
        return 'storage_alert_title'.tr();
      case BiometricFailure _:
        return 'biometric_title'.tr();
      case PermissionFailure _:
        return 'permission_required_title'.tr();
      default:
        return 'error_title'.tr();
    }
  }

  static Widget _getActionTip(Failure failure) {
    final tip = _getActionTipText(failure);
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.lightbulb_outline, size: 16, color: Colors.blue.shade700),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              tip,
              style: TextStyle(fontSize: 12, color: Colors.blue.shade700),
            ),
          ),
        ],
      ),
    );
  }

  static String _getActionTipText(Failure failure) {
    switch (failure) {
      case BatteryFailure _:
        return 'battery_tip'.tr();
      case StorageDeviceFailure _:
        return 'storage_tip'.tr();
      case LocationFailure _:
        return 'location_tip'.tr();
      case CameraFailure _:
        return 'camera_tip'.tr();
      default:
        return '';
    }
  }

  static bool _shouldShowDetails(Failure failure) {
    return failure.code != null && failure.code != 'UNKNOWN_ERROR';
  }

  static bool _shouldShowActionTip(Failure failure) {
    switch (failure) {
      case BatteryFailure _:
      case StorageDeviceFailure _:
      case LocationFailure _:
      case CameraFailure _:
      case MicrophoneFailure _:
        return true;
      default:
        return false;
    }
  }

  static bool _shouldShowSettingsAction(Failure failure) {
    switch (failure) {
      case LocationFailure _:
      case CameraFailure _:
      case MicrophoneFailure _:
      case PermissionFailure _:
        return true;
      default:
        return false;
    }
  }

  static Future<void> _openAppSettings(Failure failure) async {
    // Implement app settings opening logic
    // await openAppSettings();
  }

  static String _getErrorDetails(Failure failure) {
    if (failure.code != null) {
      return 'Error code: ${failure.code}';
    }
    return '';
  }

  // ============================================================================
  // Error Widgets
  // ============================================================================

  /// Build error widget for UI
  static Widget buildErrorWidget({
    required Failure failure,
    VoidCallback? onRetry,
    String? message,
    bool showRetry = true,
  }) {
    final errorMessage = message ?? toUserMessage(failure);
    final isRetryable = showRetry && _isRetryable(failure);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getErrorIcon(failure),
              size: 64,
              color: _getErrorIconColor(failure),
            ),
            const SizedBox(height: 16),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            if (_shouldShowSubMessage(failure))
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _getSubMessage(failure),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ),
            if (isRetryable) ...[
              const SizedBox(height: 24),
              ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
            ],
            if (_shouldShowSettingsButton(failure))
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: TextButton(
                  onPressed: () => _openAppSettings(failure),
                  child: const Text('Open Settings'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  static IconData _getErrorIcon(Failure failure) {
    switch (failure) {
      case ConnectionTimeoutFailure _:
        return Icons.timer_off;
      case NetworkFailure _:
        return Icons.wifi_off;
      case UnauthorizedRequestFailure _:
        return Icons.lock;
      case ValidationFailure _:
        return Icons.error_outline;
      case PermissionFailure _:
        return Icons.security;
      case NotFoundFailure _:
        return Icons.search_off;
      case BatteryFailure _:
        return Icons.battery_alert;
      case StorageDeviceFailure _:
        return Icons.storage;
      case BiometricFailure _:
        return Icons.fingerprint;
      default:
        return Icons.error_outline;
    }
  }

  static Color _getErrorIconColor(Failure failure) {
    switch (failure) {
      case BatteryFailure _:
        return Colors.orange;
      case StorageDeviceFailure _:
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  static bool _shouldShowSubMessage(Failure failure) {
    switch (failure) {
      case BatteryFailure _:
      case StorageDeviceFailure _:
        return true;
      default:
        return false;
    }
  }

  static String _getSubMessage(Failure failure) {
    switch (failure) {
      case BatteryFailure _:
        return 'Please charge your device to continue using this feature.';
      case StorageDeviceFailure _:
        return 'Free up space and try again.';
      default:
        return '';
    }
  }

  static bool _shouldShowSettingsButton(Failure failure) {
    switch (failure) {
      case LocationFailure _:
      case CameraFailure _:
      case MicrophoneFailure _:
      case PermissionFailure _:
        return true;
      default:
        return false;
    }
  }

  // ============================================================================
  // Helpers
  // ============================================================================

  /// Check if failure is retryable
  static bool _isRetryable(Failure failure) {
    switch (failure) {
      case NetworkFailure f:
        return f.retryable;
      case ServerFailure f:
        return f.retryable;
      default:
        return false;
    }
  }

  /// Get error code for analytics
  static String? getErrorCode(Failure failure) {
    return failure.code;
  }

  /// Get error category for analytics
  static String getErrorCategory(Failure failure) {
    switch (failure) {
      case NetworkFailure _:
        return 'network';

      case SerializationFailure _:
        return 'serialization';

      case HardwareNotAvailableFailure _:
      case SensorFailure _:
      case BiometricFailure _:
      case CameraFailure _:
      case MicrophoneFailure _:
      case LocationFailure _:
      case BluetoothFailure _:
      case BatteryFailure _:
      case StorageDeviceFailure _:
      case DisplayFailure _:
        return 'device';

      case ServerFailure _:
        return 'server';

      case UnauthorizedAccessFailure _:
      case InvalidCredentialsFailure _:
      case EmailNotVerifiedFailure _:
      case AccountLockedFailure _:
        return 'authentication';

      case ValidationFailure _:
        return 'validation';

      case PermissionFailure _:
        return 'permission';

      case FileFailure _:
        return 'file';

      case PaymentFailure _:
        return 'payment';

      case BusinessFailure _:
        return 'business';

      default:
        return 'unknown';
    }
  }

  // ============================================================================
  // Analytics Tracking
  // ============================================================================

  static void _trackErrorShown(Failure failure, String uiElement) {
    // Track error in analytics
    // Example: FirebaseAnalytics.instance.logEvent(
    //   name: 'error_shown',
    //   parameters: {
    //     'error_code': failure.code,
    //     'error_type': failure.runtimeType.toString(),
    //     'error_category': getErrorCategory(failure),
    //     'ui_element': uiElement,
    //   },
    // );
  }

  static void _trackErrorAction(Failure failure, String action) {
    // Track error action in analytics
    // Example: FirebaseAnalytics.instance.logEvent(
    //   name: 'error_action',
    //   parameters: {
    //     'error_code': failure.code,
    //     'action': action,
    //   },
    // );
  }
}

// Example usage
