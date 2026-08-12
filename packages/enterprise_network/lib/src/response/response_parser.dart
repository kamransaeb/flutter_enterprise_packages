import 'package:dio/dio.dart';
import 'package:enterprise_core/enterprise_core.dart';
import 'package:enterprise_network/src/constants/network_constants.dart';

/// Maps Dio [Response] bodies into typed models without assuming one API
/// envelope.
class ResponseParser {
  const ResponseParser._();

  /// Reads `data` key when present, otherwise parses the whole body.
  static T parseData<T>(
    Response<dynamic> response,
    T Function(dynamic json) fromJsonT, {
    String dataKey = NetworkConstants.dataKey,
  }) {
    final body = response.data;
    if (body is Map<String, dynamic> && body.containsKey(dataKey)) {
      return fromJsonT(body[dataKey]);
    }
    return fromJsonT(body);
  }

  /// Parses a list from `data`, top-level list, or nested list key.
  static List<T> parseList<T>(
    Response<dynamic> response,
    T Function(dynamic json) fromJsonT, {
    String dataKey = NetworkConstants.dataKey,
    String itemsKey = NetworkConstants.itemsKey,
  }) {
    final body = response.data;

    if (body is List) {
      return body
          .map((e) => fromJsonT(e as Map<String, dynamic>))
          //
          .toList(growable: false);
    }

    if (body is Map<String, dynamic>) {
      final raw = body[dataKey] ?? body[itemsKey];
      if (raw is List) {
        return raw
            .map((e) => fromJsonT(e as Map<String, dynamic>))
            .toList(growable: false);
      }
    }

    throw ResponseParsingException(
      message: 'Expected list or map with $dataKey or $itemsKey, but got $body',
      endpoint: response.requestOptions.path,
      method: response.requestOptions.method,
    );
  }
}
