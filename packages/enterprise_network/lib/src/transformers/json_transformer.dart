import 'package:dio/dio.dart';
import 'package:enterprise_core/enterprise_core.dart';
import 'package:enterprise_logger/enterprise_logger.dart';

/// Example:
/// getIt.registerLazySingleton`<JsonTransformer>`(
///  () => JsonTransformer(logger: getIt`<LoggerService>`()),
///);

/// Dio-aware JSON decode/encode helpers.
class JsonTransformer {
  /// Creates a [JsonTransformer].
  JsonTransformer({this._logger});

  final LoggerService? _logger;

  /// Decodes [data] (or a Dio [Response]'s body) into a map.
  Map<String, dynamic> toJson(dynamic data) {
    try {
      if (data is Response) return toJson(data.data);
      return JsonSerializer.decodeMap(data);
    } on Object catch (e, stackTrace) {
      _logger?.e(
        'Failed to convert to JSON',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Decodes [data] (or a Dio [Response]'s body) into a list.
  List<dynamic> toJsonList(dynamic data) {
    try {
      if (data is Response) return toJsonList(data.data);
      return JsonSerializer.decodeList(data);
    } on Object catch (e, stackTrace) {
      _logger?.e(
        'Failed to convert to JSON list',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Best-effort cleanup for slightly invalid JSON strings.
  String sanitizeJsonString(String jsonString) =>
      JsonSerializer.sanitize(jsonString);

  /// Encodes [value] as pretty-printed JSON.
  String prettyPrint(Object? value) =>
      JsonSerializer.encode(value, pretty: true);

  /// Encodes [value] as compact JSON.
  String minify(Object? value) => JsonSerializer.encode(value);
}
