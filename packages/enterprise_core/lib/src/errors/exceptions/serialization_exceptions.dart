import 'package:enterprise_core/src/errors/exceptions/app_exception.dart';

/// Base serialization exception
class SerializationException extends AppException {
  const SerializationException({
    required super.message,
    super.code = 'SERIALIZATION_ERROR',
    super.stackTrace,
    super.details,
    this.type,
    this.data,
    super.severity = ErrorSeverity.medium,
  });

  /// The type being serialized/deserialized
  final Type? type;

  /// The raw data that caused the error
  final dynamic data;

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'type': type?.toString(),
        'hasData': data != null,
      };
}

/// JSON serialization exception
class JsonSerializationException extends SerializationException {
  const JsonSerializationException({
    required String message,
    super.type,
    super.data,
    super.stackTrace,
    super.details,
    this.jsonPath,
    this.expectedType,
    this.actualType,
    super.code = 'JSON_SERIALIZATION_ERROR',
  }) : super(
          message: message,
          severity: ErrorSeverity.medium,
        );

  /// Path in JSON where error occurred
  final String? jsonPath;

  /// Expected type at path
  final Type? expectedType;

  /// Actual type found
  final Type? actualType;

  factory JsonSerializationException.invalidType({
    required String path,
    required Type expected,
    required dynamic actual,
    dynamic data,
  }) {
    return JsonSerializationException(
      message: 'Invalid type at $path: expected $expected, got ${actual.runtimeType}',
      jsonPath: path,
      expectedType: expected,
      actualType: actual.runtimeType,
      data: data,
    );
  }

  factory JsonSerializationException.missingField({
    required String field,
    dynamic data,
  }) {
    return JsonSerializationException(
      message: 'Required field missing: $field',
      jsonPath: field,
      data: data,
    );
  }

  factory JsonSerializationException.invalidFormat({
    required String message,
    dynamic data,
    String? path,
  }) {
    return JsonSerializationException(
      message: message,
      jsonPath: path,
      data: data,
    );
  }
}

/// JSON deserialization exception
class JsonDeserializationException extends SerializationException {
  const JsonDeserializationException({
    required String message,
    super.type,
    super.data,
    super.stackTrace,
    super.details,
    this.jsonPath,
    this.expectedType,
    this.actualType,
  }) : super(
          message: message,
          code: 'JSON_DESERIALIZATION_ERROR',
        );

  /// Path in JSON where error occurred
  final String? jsonPath;

  /// Expected type at path
  final Type? expectedType;

  /// Actual type found
  final Type? actualType;
}

/// JSON serialization (to JSON) exception
class JsonSerializationToJsonException extends JsonSerializationException {
  const JsonSerializationToJsonException({
    required String message,
    super.type,
    super.data,
    super.stackTrace,
    super.details,
    super.jsonPath,
    super.expectedType,
    super.actualType,
  }) : super(
          message: message,
          code: 'JSON_SERIALIZATION_TO_JSON_ERROR',
        );
}

/// Model conversion exception
class ModelConversionException extends SerializationException {
  const ModelConversionException({
    required String message,
    super.type,
    super.data,
    super.stackTrace,
    super.details,
    this.sourceType,
    this.targetType,
  }) : super(
          message: message,
          code: 'MODEL_CONVERSION_ERROR',
          severity: ErrorSeverity.medium,
        );

  /// Source model type
  final Type? sourceType;

  /// Target model type
  final Type? targetType;

  factory ModelConversionException.fromTo({
    required Type from,
    required Type to,
    required dynamic data,
    String? message,
    StackTrace? stackTrace,
  }) {
    return ModelConversionException(
      message: message ?? 'Failed to convert $from to $to',
      sourceType: from,
      targetType: to,
      data: data,
      stackTrace: stackTrace,
    );
  }
}

/// Freezed serialization exception
class FreezedSerializationException extends SerializationException {
  const FreezedSerializationException({
    required String message,
    super.type,
    super.data,
    super.stackTrace,
    super.details,
    this.unionType,
    this.missingUnionKey,
  }) : super(
          message: message,
          code: 'FREEZED_SERIALIZATION_ERROR',
          severity: ErrorSeverity.medium,
        );

  /// The union type being serialized
  final Type? unionType;

  /// Missing union key for discrimination
  final String? missingUnionKey;

  factory FreezedSerializationException.missingUnionKey({
    required Type unionType,
    required String key,
    dynamic data,
  }) {
    return FreezedSerializationException(
      message: 'Missing union key "$key" for type $unionType',
      unionType: unionType,
      missingUnionKey: key,
      data: data,
    );
  }

  factory FreezedSerializationException.invalidUnionValue({
    required Type unionType,
    required String key,
    required dynamic value,
    dynamic data,
  }) {
    return FreezedSerializationException(
      message: 'Invalid union value for key "$key": $value',
      unionType: unionType,
      missingUnionKey: key,
      data: data,
    );
  }
}

/// Hive serialization exception
class HiveSerializationException extends SerializationException {
  const HiveSerializationException({
    required String message,
    super.type,
    super.data,
    super.stackTrace,
    super.details,
    this.typeId,
    this.boxName,
  }) : super(
          message: message,
          code: 'HIVE_SERIALIZATION_ERROR',
          severity: ErrorSeverity.medium,
        );

  /// Hive type ID
  final int? typeId;

  /// Hive box name
  final String? boxName;

  factory HiveSerializationException.adapterNotFound({
    required int typeId,
    required String boxName,
    dynamic data,
  }) {
    return HiveSerializationException(
      message: 'Hive adapter not found for typeId: $typeId in box: $boxName',
      typeId: typeId,
      boxName: boxName,
      data: data,
    );
  }

  factory HiveSerializationException.invalidData({
    required String message,
    dynamic data,
    String? boxName,
  }) {
    return HiveSerializationException(
      message: message,
      boxName: boxName,
      data: data,
    );
  }
}

/// XML serialization exception
class XmlSerializationException extends SerializationException {
  const XmlSerializationException({
    required String message,
    super.type,
    super.data,
    super.stackTrace,
    super.details,
    this.xmlPath,
    this.elementName,
  }) : super(
          message: message,
          code: 'XML_SERIALIZATION_ERROR',
          severity: ErrorSeverity.medium,
        );

  /// Path in XML where error occurred
  final String? xmlPath;

  /// XML element name
  final String? elementName;

  factory XmlSerializationException.missingElement({
    required String elementName,
    dynamic data,
    String? path,
  }) {
    return XmlSerializationException(
      message: 'Required XML element missing: $elementName',
      elementName: elementName,
      xmlPath: path,
      data: data,
    );
  }
}

/// Protocol buffer serialization exception
class ProtobufSerializationException extends SerializationException {
  const ProtobufSerializationException({
    required String message,
    super.type,
    super.data,
    super.stackTrace,
    super.details,
    this.fieldNumber,
    this.fieldName,
  }) : super(
          message: message,
          code: 'PROTOBUF_SERIALIZATION_ERROR',
          severity: ErrorSeverity.medium,
        );

  /// Protobuf field number
  final int? fieldNumber;

  /// Protobuf field name
  final String? fieldName;

  factory ProtobufSerializationException.invalidField({
    required int fieldNumber,
    required String fieldName,
    required String message,
    dynamic data,
  }) {
    return ProtobufSerializationException(
      message: 'Invalid field $fieldName (#$fieldNumber): $message',
      fieldNumber: fieldNumber,
      fieldName: fieldName,
      data: data,
    );
  }
}

/// Encoding/Decoding exception
class EncodingException extends SerializationException {
  const EncodingException({
    required String message,
    super.code = 'ENCODING_ERROR',
    super.stackTrace,
    super.details,
    this.encoding,
    this.input,
    super.severity = ErrorSeverity.low,
  }) : super(message: message);

  /// Encoding type (UTF-8, Base64, etc.)
  final String? encoding;

  /// Input that failed to encode/decode
  final dynamic input;

  factory EncodingException.base64DecodeFailed({
    required String input,
    String? message,
  }) {
    return EncodingException(
      message: message ?? 'Failed to decode Base64 string',
      encoding: 'base64',
      input: input,
      code: 'BASE64_DECODE_ERROR',
    );
  }

  factory EncodingException.base64EncodeFailed({
    required dynamic input,
    String? message,
  }) {
    return EncodingException(
      message: message ?? 'Failed to encode to Base64',
      encoding: 'base64',
      input: input,
      code: 'BASE64_ENCODE_ERROR',
    );
  }

  factory EncodingException.utf8DecodeFailed({
    required List<int> bytes,
    String? message,
  }) {
    return EncodingException(
      message: message ?? 'Failed to decode UTF-8 bytes',
      encoding: 'utf-8',
      input: bytes,
      code: 'UTF8_DECODE_ERROR',
    );
  }
}

/// Date serialization exception
class DateSerializationException extends SerializationException {
  const DateSerializationException({
    required String message,
    super.type,
    super.data,
    super.stackTrace,
    super.details,
    this.dateFormat,
    this.dateString,
  }) : super(
          message: message,
          code: 'DATE_SERIALIZATION_ERROR',
          severity: ErrorSeverity.low,
        );

  /// Expected date format
  final String? dateFormat;

  /// Date string that failed to parse
  final String? dateString;

  factory DateSerializationException.invalidFormat({
    required String dateString,
    required String expectedFormat,
    dynamic data,
  }) {
    return DateSerializationException(
      message: 'Invalid date format: $dateString. Expected: $expectedFormat',
      dateFormat: expectedFormat,
      dateString: dateString,
      data: data,
    );
  }

  factory DateSerializationException.invalidIso8601({
    required String dateString,
    dynamic data,
  }) {
    return DateSerializationException(
      message: 'Invalid ISO 8601 date format: $dateString',
      dateFormat: 'ISO 8601',
      dateString: dateString,
      data: data,
    );
  }
}

/// Enum serialization exception
class EnumSerializationException extends SerializationException {
  const EnumSerializationException({
    required String message,
    super.type,
    super.data,
    super.stackTrace,
    super.details,
    this.enumValue,
    this.enumType,
  }) : super(
          message: message,
          code: 'ENUM_SERIALIZATION_ERROR',
          severity: ErrorSeverity.low,
        );

  /// Value that failed to map to enum
  final String? enumValue;

  /// Enum type
  final Type? enumType;

  factory EnumSerializationException.invalidValue({
    required Type enumType,
    required String value,
    required List<String> validValues,
    dynamic data,
  }) {
    return EnumSerializationException(
      message: 'Invalid value "$value" for enum $enumType. Valid values: ${validValues.join(', ')}',
      enumType: enumType,
      enumValue: value,
      data: data,
    );
  }

  factory EnumSerializationException.missingValue({
    required Type enumType,
    dynamic data,
  }) {
    return EnumSerializationException(
      message: 'Missing value for enum $enumType',
      enumType: enumType,
      data: data,
    );
  }
}