// lib/core/utils/helpers/network_helper.dart

import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../../constants/app_constants.dart';
import 'package:flutter_enterprise_boilerplate/core/services/logger_service.dart';

/// Helper class for network-related operations
@singleton
class NetworkHelper {
  final LoggerService _logger;
  final Connectivity _connectivity;
  final InternetConnection _internetConnection;
  
  NetworkHelper(
    this._connectivity,
    this._internetConnection,
    this._logger,
  );

  /// Check if device has active internet connection
  Future<bool> get hasInternetAccess async {
    try {
      final isConnected = await _internetConnection.hasInternetAccess;
      _logger.d('Internet connection check: $isConnected');
      return isConnected;
    } catch (e) {
      _logger.e('Error checking internet connection: $e');
      return false;
    }
  }

  /// Get current connectivity status
  Future<ConnectivityResult> get connectivityResult async {
    try {
      final result = await _connectivity.checkConnectivity();
      _logger.d('Connectivity result: $result');
      return result.firstWhere(
        (r) => r != ConnectivityResult.none,
        orElse: () => ConnectivityResult.none,
      );
    } catch (e) {
      _logger.e('Error checking connectivity: $e');
      return ConnectivityResult.none;
    }
  }

  /// Check if device is connected to Wi-Fi
  Future<bool> get isWifiConnected async {
    final result = await connectivityResult;
    return result == ConnectivityResult.wifi;
  }

  /// Check if device is connected to mobile network
  Future<bool> get isMobileConnected async {
    final result = await connectivityResult;
    return result == ConnectivityResult.mobile;
  }

  /// Check if device is connected to VPN
  Future<bool> get isVpnConnected async {
    // This is a simplified check - actual VPN detection is complex
    final result = await connectivityResult;
    return result == ConnectivityResult.vpn;
  }

  /// Check if device is connected to ethernet
  Future<bool> get isEthernetConnected async {
    final result = await connectivityResult;
    return result == ConnectivityResult.ethernet;
  }

  /// Check if device has any network connection (not necessarily internet)
  Future<bool> get hasNetworkConnection async {
    try {
      final result = await _connectivity.checkConnectivity();
      return result != ConnectivityResult.none;
    } catch (e) {
      _logger.e('Error checking network connection: $e');
      return false;
    }
  }

  /// Get network type as string
  Future<String> getNetworkType() async {
    final result = await connectivityResult;
    switch (result) {
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
        return 'Other';
      case ConnectivityResult.none:
        return 'No Connection';
      default:
        return 'Unknown';
    }
  }

  /// Get network strength (simplified)
  Future<String> getNetworkStrength() async {
    // Note: Actual signal strength requires platform-specific code
    // This is a simplified version
    final hasInternet = await hasInternetAccess;
    if (!hasInternet) return 'No Signal';
    
    final type = await connectivityResult;
    switch (type) {
      case ConnectivityResult.wifi:
        return 'Strong';
      case ConnectivityResult.mobile:
        return 'Variable';
      case ConnectivityResult.ethernet:
        return 'Excellent';
      default:
        return 'Unknown';
    }
  }

  /// Wait for internet connection (with timeout)
  Future<bool> waitForInternetConnection({
    Duration timeout = const Duration(seconds: 30),
    Duration checkInterval = const Duration(seconds: 2),
  }) async {
    final startTime = DateTime.now();
    
    while (DateTime.now().difference(startTime) < timeout) {
      if (await hasInternetAccess) {
        _logger.i('Internet connection established');
        return true;
      }
      await Future.delayed(checkInterval);
    }
    
    _logger.w('Timeout waiting for internet connection');
    return false;
  }

  /// Check if network is expensive (cellular data)
  Future<bool> get isNetworkExpensive async {
    final result = await connectivityResult;
    return result == ConnectivityResult.mobile;
  }

  /// Get network latency (ping to a reliable server)
  Future<Duration> getNetworkLatency({
    String host = '8.8.8.8',
    int port = 53,
    Duration timeout = const Duration(seconds: 5),
  }) async {
    final stopwatch = Stopwatch();
    
    try {
      stopwatch.start();
      final socket = await Socket.connect(host, port, timeout: timeout);
      stopwatch.stop();
      await socket.close();
      
      _logger.d('Network latency: ${stopwatch.elapsedMilliseconds}ms');
      return stopwatch.elapsed;
    } catch (e) {
      _logger.e('Error measuring network latency: $e');
      return Duration.zero;
    }
  }

  /// Get network bandwidth (simplified)
  Future<double> getNetworkBandwidth() async {
    // This is a simplified bandwidth test
    // In production, you might want to download a small file to measure
    try {
      final stopwatch = Stopwatch();
      const testUrl = 'https://www.google.com/favicon.ico';
      
      final dio = Dio();
      stopwatch.start();
      await dio.get(testUrl);
      stopwatch.stop();
      
      const fileSizeKB = 5; // Approximate size of favicon.ico
      final durationInSeconds = stopwatch.elapsed.inSeconds;
      
      if (durationInSeconds == 0) return 0;
      
      final bandwidthMbps = (fileSizeKB * 8) / (durationInSeconds * 1000);
      return bandwidthMbps;
    } catch (e) {
      _logger.e('Error measuring bandwidth: $e');
      return 0.0;
    }
  }

  /// Check if host is reachable
  Future<bool> isHostReachable(String host, {int port = 80}) async {
    try {
      final socket = await Socket.connect(
        host,
        port,
        timeout: const Duration(seconds: 3),
      );
      await socket.close();
      return true;
    } catch (e) {
      _logger.d('Host $host:$port is not reachable: $e');
      return false;
    }
  }

  /// Get IP address of the device (simplified)
  Future<String?> getDeviceIpAddress() async {
    try {
      for (final interface in await NetworkInterface.list()) {
        for (final addr in interface.addresses) {
          // Return first non-loopback IPv4 address
          if (addr.type == InternetAddressType.IPv4 &&
              !addr.address.startsWith('127.')) {
            return addr.address;
          }
        }
      }
    } catch (e) {
      _logger.e('Error getting device IP: $e');
    }
    return null;
  }

  /// Check if network connection is metered (cellular data)
  Future<bool> get isMeteredConnection async {
    final result = await connectivityResult;
    return result == ConnectivityResult.mobile;
  }

  /// Get connection speed tier
  Future<String> getConnectionSpeedTier() async {
    final latency = await getNetworkLatency();
    
    if (latency.inMilliseconds < 50) {
      return 'Excellent';
    } else if (latency.inMilliseconds < 150) {
      return 'Good';
    } else if (latency.inMilliseconds < 300) {
      return 'Fair';
    } else {
      return 'Poor';
    }
  }

  /// Monitor network changes
  Stream<ConnectivityResult> monitorNetworkChanges() {
    return _connectivity.onConnectivityChanged.map(
      (result) => result.firstWhere(
        (r) => r != ConnectivityResult.none,
        orElse: () => ConnectivityResult.none,
      ),
    );
  }

  /// Monitor internet connectivity changes
  Stream<bool> monitorInternetChanges() {

    return _internetConnection.onStatusChange.map(
      (status) => status == InternetStatus.connected ? true : false,
    );
  }

  /// Check if network is suitable for video streaming
  Future<bool> isSuitableForVideoStreaming() async {
    final hasInternet = await hasInternetAccess;
    if (!hasInternet) return false;
    
    final connectionType = await connectivityResult;
    if (connectionType == ConnectivityResult.mobile) {
      // On mobile, might want to ask user or check settings
      return false;
    }
    
    final latency = await getNetworkLatency();
    return latency.inMilliseconds < 200;
  }

  /// Get network quality score (0-100)
  Future<int> getNetworkQualityScore() async {
    int score = 0;
    
    // Check if connected
    final hasInternet = await hasInternetAccess;
    if (!hasInternet) return 0;
    score += 30;
    
    // Check connection type
    final connectionType = await connectivityResult;
    if (connectionType == ConnectivityResult.wifi ||
        connectionType == ConnectivityResult.ethernet) {
      score += 30;
    } else if (connectionType == ConnectivityResult.mobile) {
      score += 15;
    }
    
    // Check latency
    final latency = await getNetworkLatency();
    if (latency.inMilliseconds < 100) {
      score += 40;
    } else if (latency.inMilliseconds < 200) {
      score += 30;
    } else if (latency.inMilliseconds < 500) {
      score += 15;
    } else {
      score += 5;
    }
    
    return score.clamp(0, 100);
  }

  /// Get network diagnostics
  Future<Map<String, dynamic>> getNetworkDiagnostics() async {
    return {
      'hasInternet': await hasInternetAccess,
      'connectionType': await getNetworkType(),
      'isWifi': await isWifiConnected,
      'isMobile': await isMobileConnected,
      'isMetered': await isMeteredConnection,
      'latencyMs': (await getNetworkLatency()).inMilliseconds,
      'qualityScore': await getNetworkQualityScore(),
      'speedTier': await getConnectionSpeedTier(),
      'ipAddress': await getDeviceIpAddress(),
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  /// Handle network errors gracefully
  String getNetworkErrorMessage(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return 'Connection timeout. Please check your internet connection.';
        case DioExceptionType.sendTimeout:
          return 'Request timeout. Please try again.';
        case DioExceptionType.receiveTimeout:
          return 'Response timeout. Please try again.';
        case DioExceptionType.cancel:
          return 'Request was cancelled.';
        case DioExceptionType.connectionError:
          return 'No internet connection. Please check your network settings.';
        case DioExceptionType.unknown:
          if (error.message?.contains('SocketException') == true) {
            return 'No internet connection. Please check your network.';
          }
          return 'An unknown network error occurred.';
        default:
          return 'Network error. Please try again.';
      }
    }
    
    if (error is SocketException) {
      return 'No internet connection. Please check your network.';
    }
    
    return 'Network error: ${error.toString()}';
  }

  /// Check if error is network-related
  bool isNetworkError(dynamic error) {
    if (error is DioException) {
      return error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.sendTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.connectionError ||
          (error.type == DioExceptionType.unknown &&
              error.message?.contains('SocketException') == true);
    }
    
    return error is SocketException;
  }
}