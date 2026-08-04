import 'package:enterprise_core/src/errors/exceptions/app_exception.dart';

/// Base serialization exception
class SerializationException extends AppException {
  /// Creates a [SerializationException].
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
  /// Creates a [JsonSerializationException].
  const JsonSerializationException({
    required super.message,
    super.type,
    super.data,
    super.stackTrace,
    super.details,
    this.jsonPath,
    this.expectedType,
    this.actualType,
    super.code = 'JSON_SERIALIZATION_ERROR',
  }) : super(
         severity: ErrorSeverity.medium,
       );

  /// Creates a [JsonSerializationException].
  factory JsonSerializationException.invalidType({
    required String path,
    required Type expected,
    required dynamic actual,
    dynamic data,
  }) {
    return JsonSerializationException(
      message: 'Invalid type at $path: expected $expected, '
      'got ${actual.runtimeType}',
      jsonPath: path,
      expectedType: expected,
      actualType: actual.runtimeType,
      data: data,
    );
  }

  /// Creates a [JsonSerializationException].
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

  /// Creates a [JsonSerializationException].
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

  /// Path in JSON where error occurred
  final String? jsonPath;

  /// Expected type at path
  final Type? expectedType;

  /// Actual type found
  final Type? actualType;
}

/// JSON deserialization exception
class JsonDeserializationException extends SerializationException {
  /// Creates a [JsonDeserializationException].
  const JsonDeserializationException({
    required super.message,
    super.type,
    super.data,
    super.stackTrace,
    super.details,
    this.jsonPath,
    this.expectedType,
    this.actualType,
  }) : super(
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
  /// Creates a [JsonSerializationToJsonException].
  const JsonSerializationToJsonException({
    required super.message,
    super.type,
    super.data,
    super.stackTrace,
    super.details,
    super.jsonPath,
    super.expectedType,
    super.actualType,
  }) : super(
         code: 'JSON_SERIALIZATION_TO_JSON_ERROR',
       );
}

/// Model conversion exception
class ModelConversionException extends SerializationException {
  /// Creates a [ModelConversionException].
  const ModelConversionException({
    required super.message,
    super.type,
    super.data,
    super.stackTrace,
    super.details,
    this.sourceType,
    this.targetType,
  }) : super(
         code: 'MODEL_CONVERSION_ERROR',
         severity: ErrorSeverity.medium,
       );

  /// Creates a [ModelConversionException].
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

  /// Source model type
  final Type? sourceType;

  /// Target model type
  final Type? targetType;
}

/// Freezed serialization exception
class FreezedSerializationException extends SerializationException {
  /// Creates a [FreezedSerializationException].
  const FreezedSerializationException({
    required super.message,
    super.type,
    super.data,
    super.stackTrace,
    super.details,
    this.unionType,
    this.missingUnionKey,
  }) : super(
         code: 'FREEZED_SERIALIZATION_ERROR',
         severity: ErrorSeverity.medium,
       );

  /// Creates a [FreezedSerializationException].
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

  /// Creates a [FreezedSerializationException].
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

  /// The union type being serialized
  final Type? unionType;

  /// Missing union key for discrimination
  final String? missingUnionKey;
}

/// Hive serialization exception
class HiveSerializationException extends SerializationException {
  /// Creates a [HiveSerializationException].
  const HiveSerializationException({
    required super.message,
    super.type,
    super.data,
    super.stackTrace,
    super.details,
    this.typeId,
    this.boxName,
  }) : super(
         code: 'HIVE_SERIALIZATION_ERROR',
         severity: ErrorSeverity.medium,
       );

  /// Creates a [HiveSerializationException].
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

  /// Creates a [HiveSerializationException].
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

  /// Hive type ID
  final int? typeId;

  /// Hive box name
  final String? boxName;
}

/// XML serialization exception
class XmlSerializationException extends SerializationException {
  /// Creates a [XmlSerializationException].
  const XmlSerializationException({
    required super.message,
    super.type,
    super.data,
    super.stackTrace,
    super.details,
    this.xmlPath,
    this.elementName,
  }) : super(
         code: 'XML_SERIALIZATION_ERROR',
         severity: ErrorSeverity.medium,
       );

  /// Creates a [XmlSerializationException].
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

  /// Path in XML where error occurred
  final String? xmlPath;

  /// XML element name
  final String? elementName;
}

/// Protocol buffer serialization exception
class ProtobufSerializationException extends SerializationException {
  /// Creates a [ProtobufSerializationException].
  const ProtobufSerializationException({
    required super.message,
    super.type,
    super.data,
    super.stackTrace,
    super.details,
    this.fieldNumber,
    this.fieldName,
  }) : super(
         code: 'PROTOBUF_SERIALIZATION_ERROR',
         severity: ErrorSeverity.medium,
       );

  /// Creates a [ProtobufSerializationException].
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

  /// Protobuf field number
  final int? fieldNumber;

  /// Protobuf field name
  final String? fieldName;
}

/// Encoding/Decoding exception
class EncodingException extends SerializationException {
  /// Creates an [EncodingException].
  const EncodingException({
    required super.message,
    super.code = 'ENCODING_ERROR',
    super.stackTrace,
    super.details,
    this.encoding,
    this.input,
    super.severity = ErrorSeverity.low,
  });

  /// Creates an [EncodingException].
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

  /// Creates an [EncodingException].
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

  /// Creates an [EncodingException].
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

  /// Encoding type (UTF-8, Base64, etc.)
  final String? encoding;

  /// Input that failed to encode/decode
  final dynamic input;
}

/// Date serialization exception
class DateSerializationException extends SerializationException {
  /// Creates a [DateSerializationException].
  const DateSerializationException({
    required super.message,
    super.type,
    super.data,
    super.stackTrace,
    super.details,
    this.dateFormat,
    this.dateString,
  }) : super(
         code: 'DATE_SERIALIZATION_ERROR',
         severity: ErrorSeverity.low,
       );

  /// Creates a [DateSerializationException].
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

  /// Creates a [DateSerializationException].
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

  /// Expected date format
  final String? dateFormat;

  /// Date string that failed to parse
  final String? dateString;
}

/// Enum serialization exception
class EnumSerializationException extends SerializationException {
  /// Creates an [EnumSerializationException].
  const EnumSerializationException({
    required super.message,
    super.type,
    super.data,
    super.stackTrace,
    super.details,
    this.enumValue,
    this.enumType,
  }) : super(
         code: 'ENUM_SERIALIZATION_ERROR',
         severity: ErrorSeverity.low,
       );

  /// Creates an [EnumSerializationException].
  factory EnumSerializationException.invalidValue({
    required Type enumType,
    required String value,
    required List<String> validValues,
    dynamic data,
  }) {
    return EnumSerializationException(
      message:
          'Invalid value "$value" for enum $enumType. Valid values: '
          '${validValues.join(', ')}',
      enumType: enumType,
      enumValue: value,
      data: data,
    );
  }

  /// Creates an [EnumSerializationException].
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

  /// Value that failed to map to enum
  final String? enumValue;

  /// Enum type
  final Type? enumType;
}
