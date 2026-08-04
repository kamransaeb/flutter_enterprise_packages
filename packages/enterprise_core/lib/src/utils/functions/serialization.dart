import 'dart:convert';

import 'package:enterprise_core/src/constants/regex_constants.dart';

/// Lightweight JSON encode/decode helpers (no Dio).
class JsonSerializer {
  JsonSerializer._();

  /// Decodes [data] into a `Map<String, dynamic>`.
  ///
  /// Accepts a map, JSON object string, or `null` (returns `{}`).
  static Map<String, dynamic> decodeMap(dynamic data) {
    if (data == null) return {};
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    if (data is String) {
      final trimmed = data.trim();
      if (trimmed.isEmpty) return {};
      final decoded = json.decode(sanitize(trimmed));
      if (decoded is Map<String, dynamic>) return decoded;
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
      throw FormatException('Expected JSON object, got ${decoded.runtimeType}');
    }
    throw ArgumentError('Cannot convert ${data.runtimeType} to Map');
  }

  /// Decodes [data] into a `List`.
  ///
  /// Accepts a list, JSON array string, or `null` (returns `[]`).
  static List<dynamic> decodeList(dynamic data) {
    if (data == null) return [];
    if (data is List) return data;
    if (data is String) {
      final trimmed = data.trim();
      if (trimmed.isEmpty) return [];
      final decoded = json.decode(sanitize(trimmed));
      if (decoded is List) return decoded;
      throw FormatException('Expected JSON array, got ${decoded.runtimeType}');
    }
    throw ArgumentError('Cannot convert ${data.runtimeType} to List');
  }

  /// Encodes [value] to a JSON string.
  static String encode(
    Object? value, {
    bool pretty = false,
  }) {
    if (pretty) {
      return const JsonEncoder.withIndent('  ').convert(value);
    }
    return json.encode(value);
  }

  /// Decodes [source] and maps it with [fromJson], or returns `null` on
  /// failure.
  static T? tryDecode<T>(String source, T Function(dynamic json) fromJson) {
    try {
      return fromJson(json.decode(sanitize(source)));
    } on Object catch (_) {
      return null;
    }
  }

  /// Best-effort cleanup for slightly invalid JSON strings.
  static String sanitize(String jsonString) {
    var s = jsonString;
    if (s.startsWith('\uFEFF')) {
      s = s.substring(1);
    }
    s = s.replaceAll(RegexConstants.nullBytePattern, '');
    s = s.replaceAll(RegexConstants.trailingCommaPattern, r'$1');
    s = s.replaceAll(RegexConstants.trailingCommaArrayPattern, r'$1');
    return s;
  }
}
