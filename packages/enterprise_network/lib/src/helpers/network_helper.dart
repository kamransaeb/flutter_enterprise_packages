import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:enterprise_logger/enterprise_logger.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

/// Connectivity and reachability helpers for network setup / interceptors.
///
/// No DI inside the package — construct and register in the app:
/// ```dart
/// final network = NetworkHelper(logger: getIt<LoggerService>());
/// getIt.registerSingleton(network);
/// ```
class NetworkHelper {
  /// Creates a [NetworkHelper].
  NetworkHelper(
    this._logger, {
    Connectivity? connectivity,
    InternetConnection? internetConnection,
  }) : _connectivity = connectivity ?? Connectivity(),
       _internetConnection = internetConnection ?? InternetConnection();

  final Connectivity _connectivity;
  final InternetConnection _internetConnection;
  final LoggerService _logger;

  /// True when the device appears to have real internet access.
  Future<bool> get hasInternetAccess async {
    try {
      final isConnected = await _internetConnection.hasInternetAccess;
      _logger.d('Internet connection check: $isConnected');
      return isConnected;
    } on Object catch (e, stackTrace) {
      _logger.e(
        'Error checking internet connection',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  /// Primary non-`none` connectivity result, or [ConnectivityResult.none].
  Future<ConnectivityResult> get connectivityResult async {
    try {
      final results = await _connectivity.checkConnectivity();
      return results.firstWhere(
        (r) => r != ConnectivityResult.none,
        orElse: () => ConnectivityResult.none,
      );
    } on Object catch (e, stackTrace) {
      _logger.e(
        'Error checking connectivity',
        error: e,
        stackTrace: stackTrace,
      );
      return ConnectivityResult.none;
    }
  }

  /// Whether the active link is Wi‑Fi.
  Future<bool> get isWifiConnected async =>
      (await connectivityResult) == ConnectivityResult.wifi;

  /// Whether the active link is cellular.
  Future<bool> get isMobileConnected async =>
      (await connectivityResult) == ConnectivityResult.mobile;

  /// Whether the connection is typically metered (mobile).
  Future<bool> get isMeteredConnection async => isMobileConnected;

  /// Any link (Wi‑Fi/mobile/etc.), not necessarily internet.
  Future<bool> get hasNetworkConnection async {
    try {
      final results = await _connectivity.checkConnectivity();
      return results.any((r) => r != ConnectivityResult.none);
    } on Object catch (e, stackTrace) {
      _logger.e(
        'Error checking network connection',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  /// Human-readable label for the current connectivity type.
  Future<String> getNetworkType() async {
    switch (await connectivityResult) {
      case ConnectivityResult.wifi:
        return 'Wi-Fi';
      case ConnectivityResult.mobile:
        return 'Mobile Data';
      case ConnectivityResult.ethernet:
        return 'Ethernet';
      case ConnectivityResult.vpn:
        return 'VPN';
      case ConnectivityResult.bluetooth:
        return 'Bluetooth';
      case ConnectivityResult.other:
      case ConnectivityResult.satellite:
        return 'Other';
      case ConnectivityResult.none:
        return 'No Connection';
    }
  }

  /// Polls until online or [timeout].
  Future<bool> waitForInternetConnection({
    Duration timeout = const Duration(seconds: 30),
    Duration checkInterval = const Duration(seconds: 2),
  }) async {
    final start = DateTime.now();
    while (DateTime.now().difference(start) < timeout) {
      if (await hasInternetAccess) {
        _logger.i('Internet connection established');
        return true;
      }
      await Future<void>.delayed(checkInterval);
    }
    _logger.w('Timeout waiting for internet connection');
    return false;
  }

  /// Attempts a TCP connect to [host]:[port] within [timeout].
  Future<bool> isHostReachable(
    String host, {
    int port = 80,
    Duration timeout = const Duration(seconds: 3),
  }) async {
    try {
      final socket = await Socket.connect(host, port, timeout: timeout);
      await socket.close();
      return true;
    } on Object catch (_) {
      return false;
    }
  }

  /// Stream of primary connectivity changes.
  Stream<ConnectivityResult> monitorNetworkChanges() {
    return _connectivity.onConnectivityChanged.map(
      (results) => results.firstWhere(
        (r) => r != ConnectivityResult.none,
        orElse: () => ConnectivityResult.none,
      ),
    );
  }

  /// Stream of internet reachability changes.
  Stream<bool> monitorInternetChanges() {
    return _internetConnection.onStatusChange.map(
      (status) => status == InternetStatus.connected,
    );
  }

  /// Whether [error] looks like a transport/connectivity failure.
  bool isNetworkError(Object error) {
    if (error is DioException) {
      return error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.sendTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.connectionError ||
          (error.type == DioExceptionType.unknown &&
              (error.message?.contains('SocketException') ?? false));
    }
    return error is SocketException;
  }

  /// User-facing message for a network-related [error].
  String getNetworkErrorMessage(Object error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return 'Connection timeout. Please check your internet connection.';
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return 'Request timeout. Please try again.';
        case DioExceptionType.cancel:
          return 'Request was cancelled.';
        case DioExceptionType.connectionError:
          return 'No internet connection. Please check your network settings.';
        case DioExceptionType.badCertificate:
        case DioExceptionType.badResponse:
        case DioExceptionType.transformTimeout:
          return 'Network error. Please try again.';
        case DioExceptionType.unknown:
          if (error.message?.contains('SocketException') == true) {
            return 'No internet connection. Please check your network.';
          }
          return 'An unknown network error occurred.';
      }
    }
    if (error is SocketException) {
      return 'No internet connection. Please check your network.';
    }
    return 'Network error: $error';
  }
}
