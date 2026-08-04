import 'dart:convert';

import 'package:enterprise_logger/enterprise_logger.dart';
import 'package:enterprise_storage/src/local_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// [LocalStorage] backed by [FlutterSecureStorage].
class SecureStorage implements LocalStorage {
  /// Creates a [SecureStorage] backed by [FlutterSecureStorage].
  SecureStorage(
   this._storage,
   this._logger,
  );

  final FlutterSecureStorage _storage;
  final LoggerService _logger;
  bool _isInitialized = false;

  @override
  bool get isInitialized => _isInitialized;

  @override
  Future<void> initialize() async {
    try {
      await _storage.write(key: '_test', value: 'test');
      await _storage.delete(key: '_test');
      _isInitialized = true;
      _logger.i('[SecureStorage] initialized');
    } catch (e, stackTrace) {
      _logger.e(
        '[SecureStorage] init failed',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<void> write(String key, dynamic value, {String? boxName}) async {
    try {
      final stringValue = value is String ? value : jsonEncode(value);
      await _storage.write(key: key, value: stringValue);
      _logger.d('[SecureStorage] wrote: $key');
    } catch (e, stackTrace) {
      _logger.e(
        '[SecureStorage] write failed: $key',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<T?> read<T>(String key, {String? boxName}) async {
    try {
      final value = await _storage.read(key: key);
      if (value == null) return null;

      if (T != String) {
        try {
          return jsonDecode(value) as T;
        } catch (_) {
          return value as T;
        }
      }
      return value as T;
    } catch (e, stackTrace) {
      _logger.e(
        '[SecureStorage] read failed: $key',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  @override
  Future<void> delete(String key, {String? boxName}) async {
    await _storage.delete(key: key);
    _logger.d('[SecureStorage] deleted: $key');
  }

  @override
  Future<void> clear({String? boxName}) async {
    await _storage.deleteAll();
    _logger.d('[SecureStorage] cleared');
  }

  @override
  Future<bool> contains(String key, {String? boxName}) async {
    return (await _storage.read(key: key)) != null;
  }

  @override
  Future<Map<String, dynamic>> getAll({String? boxName}) async {
    return Map<String, dynamic>.from(await _storage.readAll());
  }

  @override
  Future<void> close() async {
    _isInitialized = false;
    _logger.d('[SecureStorage] closed');
  }
}
