import 'dart:math';

import 'package:dio/dio.dart';

import 'package:enterprise_network/src/constants/network_constants.dart';
import 'package:enterprise_network/src/device/device_network_info.dart';

/// Provides extra headers from the consumer app (version, locale, env, …).
typedef HeaderProvider = Map<String, String> Function();

/// Adds device + app metadata headers to every request.
///
/// Call [DeviceNetworkInfo.initialize] during app bootstrap before traffic.
/// 
/// How the app will wire it
/// HeaderInterceptor(
///   deviceNetworkInfo: getIt`<DeviceNetworkInfo>`(),
///   appHeaders: () => {
///     'App-Version': '1.0.0',           // from package_info in app
///     'Build-Number': '1',
///     NetworkConstants.acceptLanguage: 'en',
///     // 'X-Environment': 'dev',        // only in debug
///   },
/// ),
class HeaderInterceptor extends Interceptor {
  /// Constructor for the HeaderInterceptor class
  HeaderInterceptor(
    this._deviceNetworkInfo,
    this._appHeaders, {
    this.includeTimestap = true,
    this.includeCorrelationId = true,
  });

  final DeviceNetworkInfo _deviceNetworkInfo;
  final HeaderProvider? _appHeaders;
  /// Whether to include a timestamp in the request headers.
  final bool includeTimestap;
  /// Whether to include a correlation id in the request headers.
  final bool includeCorrelationId;

  final _random = Random.secure();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Defaults (do not overwrite if already set by caller)
    options.headers.putIfAbsent(
      NetworkConstants.contentType,
      () => NetworkConstants.applicationJson,
    );
    options.headers.putIfAbsent(
      NetworkConstants.accept,
      () => NetworkConstants.applicationJson,
    );

    // Device headers from DeviceNetworkInfo
    for (final entry in _deviceNetworkInfo.toHeaders().entries) {
      options.headers.putIfAbsent(entry.key, () => entry.value);
    }

    // App-owend headers (version, language, environment, ...)
    final extra = _appHeaders?.call() ?? const <String, String>{};
    for (final entry in extra.entries) {
      options.headers.putIfAbsent(entry.key, () => entry.value);
    }

    if (includeTimestap) {
      options.headers.putIfAbsent(
        NetworkConstants.xTimestamp,
        () => DateTime.now().toUtc().toIso8601String(),
      );
    }
    if (includeCorrelationId) {
      options.headers.putIfAbsent(
        NetworkConstants.xCorrelationId,
        _generateCorrelationId,
      );
    }

    handler.next(options);
  }

  String _generateCorrelationId() {
    return '${DateTime.now().millisecondsSinceEpoch}'
    '-${_random.nextInt(1000000)}';
  }

  // String _generateCorrelationId({int length = 32}) {
  //   const chars =
  //       'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  //   return List.generate(
  //     length,
  //     (_) => chars[_random.nextInt(chars.length)],
  //   ).join();
  // }
}
