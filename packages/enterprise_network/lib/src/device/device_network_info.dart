import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

/// final deviceInfo = DeviceNetworkInfo();
/// await deviceInfo.initialize();
/// // When you build Dio / HeaderInterceptor:
/// options.headers.addAll(deviceInfo.toHeaders());
/// or getIt.registerSingleton`<DeviceNetworkInfo>`(deviceInfo);

/// Device metadata used for network headers / diagnostics.
class DeviceNetworkInfo {
  /// Creates a [DeviceNetworkInfo].
  ///
  /// Optionally inject [plugin] for testing; otherwise a default
  /// [DeviceInfoPlugin] is created.
  DeviceNetworkInfo({DeviceInfoPlugin? plugin})
      : _plugin = plugin ?? DeviceInfoPlugin();

  final DeviceInfoPlugin _plugin;

  /// Stable-ish device identifier when available.
  String? deviceId;

  /// Device model name.
  String? deviceModel;

  /// OS version string.
  String? osVersion;

  /// Platform label (`android`, `ios`, `web`, etc.).
  String? platform;

  bool _initialized = false;

  /// Whether [initialize] has completed.
  bool get isInitialized => _initialized;

  /// Call once at app/network setup (before traffic).
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      if (kIsWeb) {
        platform = 'web';
        deviceId = 'web_${DateTime.now().millisecondsSinceEpoch}';
        deviceModel = 'Web';
        osVersion = 'Web';
      } else if (Platform.isAndroid) {
        platform = 'android';
        final info = await _plugin.androidInfo;
        deviceId = info.id;
        deviceModel = info.model;
        osVersion = info.version.release;
      } else if (Platform.isIOS) {
        platform = 'ios';
        final info = await _plugin.iosInfo;
        deviceId = info.identifierForVendor;
        deviceModel = info.utsname.machine;
        osVersion = info.systemVersion;
      } else {
        platform = Platform.operatingSystem;
        deviceModel = Platform.operatingSystem;
        osVersion = Platform.operatingSystemVersion;
      }
      _initialized = true;
    } on Object catch (_) {
      platform ??= 'unknown';
      deviceModel ??= 'unknown';
      osVersion ??= 'unknown';
      _initialized = true;
    }
  }

  /// Headers safe to attach to Dio requests.
  Map<String, String> toHeaders() {
    return {
      'Platform': ?platform,
      'Device-Model': ?deviceModel,
      'OS-Version': ?osVersion,
      'Device-Id': ?deviceId,
    };
  }
}
