import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

/// Thin biometric helper. Prefer injecting this from the app DI layer.
class Biometrics {
  /// Creates a [Biometrics] helper.
  ///
  /// Optionally inject [localAuth] for testing; otherwise a default
  /// [LocalAuthentication] is created.
  Biometrics({LocalAuthentication? localAuth})
      : _localAuth = localAuth ?? LocalAuthentication();

  final LocalAuthentication _localAuth;

  /// Whether the device can check biometrics.
  Future<bool> canCheckBiometrics() async {
    try {
      return await _localAuth.canCheckBiometrics;
    } on PlatformException {
      return false;
    } on LocalAuthException {
      return false;
    }
  }

  /// Whether the device supports biometric or device-credential auth.
  Future<bool> isDeviceSupported() async {
    try {
      return await _localAuth.isDeviceSupported();
    } on PlatformException {
      return false;
    } on LocalAuthException {
      return false;
    }
  }

  /// Biometric types currently available to the app.
  Future<List<BiometricType>> availableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } on PlatformException {
      return const [];
    } on LocalAuthException {
      return const [];
    }
  }

  /// Whether fingerprint biometrics are available.
  Future<bool> hasFingerprint() async {
    final types = await availableBiometrics();
    return types.contains(BiometricType.fingerprint);
  }

  /// Whether face biometrics are available.
  Future<bool> hasFace() async {
    final types = await availableBiometrics();
    return types.contains(BiometricType.face);
  }

  /// Biometric-only authentication.
  Future<bool> authenticate({
    required String reason,
    bool stickyAuth = true,
    bool sensitiveTransaction = true,
  }) async {
    try {
      return await _localAuth.authenticate(
        localizedReason: reason,
        biometricOnly: true,
        sensitiveTransaction: sensitiveTransaction,
        persistAcrossBackgrounding: stickyAuth,
      );
    } on PlatformException {
      return false;
    } on LocalAuthException {
      return false;
    }
  }

  /// Biometrics or device PIN/pattern/password.
  Future<bool> authenticateWithDeviceCredentials({
    required String reason,
    bool stickyAuth = true,
  }) async {
    try {
      return await _localAuth.authenticate(
        localizedReason: reason,
        persistAcrossBackgrounding: stickyAuth,
      );
    } on PlatformException {
      return false;
    } on LocalAuthException {
      return false;
    }
  }

  /// Cancels any in-progress authentication.
  Future<void> stopAuthentication() => _localAuth.stopAuthentication();
}
