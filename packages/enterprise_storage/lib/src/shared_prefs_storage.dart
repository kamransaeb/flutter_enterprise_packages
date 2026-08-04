import 'dart:convert';

import 'package:enterprise_logger/enterprise_logger.dart';
import 'package:enterprise_storage/src/local_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// [LocalStorage] backed by [SharedPreferences].
class SharedPrefsStorage implements LocalStorage {
  /// Creates a [SharedPrefsStorage] backed by SharedPreferences.
  SharedPrefsStorage(
    this._prefs,
    this._logger,
  );

  final SharedPreferences _prefs;
  final LoggerService? _logger;

  @override
  bool get isInitialized => true;

  @override
  Future<void> initialize() async {
    _logger?.d('[SharedPrefs] already initialized');
  }

  @override
  Future<void> write(String key, dynamic value, {String? boxName}) async {
    try {
      final bool success;
      if (value is String) {
        success = await _prefs.setString(key, value);
      } else if (value is int) {
        success = await _prefs.setInt(key, value);
      } else if (value is double) {
        success = await _prefs.setDouble(key, value);
      } else if (value is bool) {
        success = await _prefs.setBool(key, value);
      } else if (value is List<String>) {
        success = await _prefs.setStringList(key, value);
      } else {
        success = await _prefs.setString(key, jsonEncode(value));
      }

      if (!success) {
        throw Exception('Failed to write to SharedPreferences: $key');
      }
      _logger?.d('[SharedPrefs] wrote: $key');
    } catch (e, stackTrace) {
      _logger?.e(
        '[SharedPrefs] write failed: $key',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<T?> read<T>(String key, {String? boxName}) async {
    try {
      final value = _prefs.get(key);
      if (value == null) return null;

      if (T == String ||
          T == int ||
          T == double ||
          T == bool ||
          T == List<String>) {
        return value as T;
      }

      if (value is String) {
        try {
          return jsonDecode(value) as T;
        } on Object catch (_) {
          return value as T?;
        }
      }
      return null;
    } on Object catch (e, stackTrace) {
      _logger?.e(
        '[SharedPrefs] read failed: $key',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  @override
  Future<void> delete(String key, {String? boxName}) async {
    await _prefs.remove(key);
    _logger?.d('[SharedPrefs] deleted: $key');
  }

  @override
  Future<void> clear({String? boxName}) async {
    await _prefs.clear();
    _logger?.d('[SharedPrefs] cleared');
  }

  @override
  Future<bool> contains(String key, {String? boxName}) async {
    return _prefs.containsKey(key);
  }

  @override
  Future<Map<String, dynamic>> getAll({String? boxName}) async {
    return {
      for (final key in _prefs.getKeys()) key: _prefs.get(key),
    };
  }

  @override
  Future<void> close() async {
    _logger?.d('[SharedPrefs] close (no-op)');
  }
}
