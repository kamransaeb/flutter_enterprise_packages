import 'package:enterprise_core/src/errors/exceptions/app_exception.dart';

/// Base validation exception
class ValidationException extends AppException {
  const ValidationException({
    required super.message,
    super.code = 'VALIDATION_ERROR',
    super.stackTrace,
    super.details,
    this.field,
    this.rule,
    this.value,
    super.severity = ErrorSeverity.low,
  });

  /// Field that failed validation
  final String? field;

  /// Validation rule that was violated
  final String? rule;

  /// Value that failed validation
  final dynamic value;

  /// Create validation exception for a specific field
  factory ValidationException.field({
    required String field,
    required String rule,
    String? message,
    dynamic value,
    Map<String, dynamic>? details,
  }) {
    return ValidationException(
      message: message ?? 'Invalid $field: $rule violation',
      field: field,
      rule: rule,
      value: value,
      details: details,
      code: 'FIELD_VALIDATION_ERROR',
    );
  }

  /// Create validation exception for email
  factory ValidationException.email({
    required String email,
    String? message,
  }) {
    return ValidationException.field(
      field: 'email',
      rule: 'email_format',
      message: message ?? 'Please enter a valid email address',
      value: email,
    );
  }

  /// Create validation exception for password
  factory ValidationException.password({
    required String password,
    required String reason,
    String? message,
  }) {
    return ValidationException.field(
      field: 'password',
      rule: 'password_$reason',
      message: message ?? _getPasswordErrorMessage(reason),
      value: password,
    );
  }

  static String _getPasswordErrorMessage(String reason) {
    switch (reason) {
      case 'too_short':
        return 'Password must be at least 8 characters';
      case 'no_uppercase':
        return 'Password must contain at least one uppercase letter';
      case 'no_lowercase':
        return 'Password must contain at least one lowercase letter';
      case 'no_number':
        return 'Password must contain at least one number';
      case 'no_special':
        return 'Password must contain at least one special character';
      case 'common_password':
        return 'Password is too common. Please choose a stronger password';
      default:
        return 'Invalid password format';
    }
  }

  /// Create validation exception for phone number
  factory ValidationException.phone({
    required String phone,
    String? message,
  }) {
    return ValidationException.field(
      field: 'phone',
      rule: 'phone_format',
      message: message ?? 'Please enter a valid phone number',
      value: phone,
    );
  }

  /// Create validation exception for required field
  factory ValidationException.required({
    required String field,
    String? message,
  }) {
    return ValidationException.field(
      field: field,
      rule: 'required',
      message: message ?? '$field is required',
    );
  }
}

/// Form validation exception (multiple fields)
class FormValidationException extends ValidationException {
  const FormValidationException({
    required super.message,
    super.stackTrace,
    super.details,
    required this.errors,
    super.severity = ErrorSeverity.low,
  }) : super(
          code: 'FORM_VALIDATION_ERROR',
        );

  /// Map of field names to validation errors
  final Map<String, List<String>> errors;

  /// Get all errors for a specific field
  List<String> getFieldErrors(String field) => errors[field] ?? [];

  /// Check if a field has errors
  bool hasFieldError(String field) => errors.containsKey(field);

  /// Get first error message for a field
  String? getFirstFieldError(String field) => errors[field]?.firstOrNull;

  factory FormValidationException.fromMap(Map<String, dynamic> errors) {
    final formattedErrors = <String, List<String>>{};
    errors.forEach((key, value) {
      if (value is List) {
        formattedErrors[key] = value.map((e) => e.toString()).toList();
      } else if (value is String) {
        formattedErrors[key] = [value];
      }
    });
    return FormValidationException(
      message: 'Please fix the errors in the form',
      errors: formattedErrors,
      details: errors,
    );
  }
}

/// Data validation exception (business logic)
class DataValidationException extends ValidationException {
  const DataValidationException({
    required String message,
    super.code = 'DATA_VALIDATION_ERROR',
    super.stackTrace,
    super.details,
    super.field,
    super.rule,
    super.value,
    super.severity = ErrorSeverity.medium,
  }) : super(message: message);
}

/// Business rule violation
class BusinessRuleException extends ValidationException {
  const BusinessRuleException({
    required String message,
    super.code = 'BUSINESS_RULE_VIOLATION',
    super.stackTrace,
    super.details,
    required this.ruleName,
    super.severity = ErrorSeverity.medium,
  }) : super(message: message);

  /// Name of the business rule violated
  final String ruleName;
}

/// Date validation exception
class DateValidationException extends ValidationException {
  const DateValidationException({
    required String message,
    super.code = 'DATE_VALIDATION_ERROR',
    super.stackTrace,
    super.details,
    super.field,
    this.date,
    this.dateFormat,
    super.severity = ErrorSeverity.low,
  }) : super(message: message);

  /// Date format if applicable
  final String? dateFormat;

  /// Date if applicable
  final DateTime? date;


}

/// Range validation exception
class RangeValidationException extends ValidationException {
  const RangeValidationException({
    required String message,
    super.code = 'RANGE_VALIDATION_ERROR',
    super.stackTrace,
    super.details,
    super.field,
    this.minValue,
    this.maxValue,
    this.actualValue,
    super.severity = ErrorSeverity.low,
  }) : super(message: message);

  /// Minimum allowed value
  final dynamic minValue;

  /// Maximum allowed value
  final dynamic maxValue;

  /// Actual value that was provided
  final dynamic actualValue;

  factory RangeValidationException.outOfRange({
    required dynamic value,
    dynamic min,
    dynamic max,
    String? field,
  }) {
    return RangeValidationException(
      message: 'Value must be between $min and $max',
      field: field,
      minValue: min,
      maxValue: max,
      actualValue: value,
    );
  }

  factory RangeValidationException.tooLow({
    required dynamic value,
    required dynamic min,
    String? field,
  }) {
    return RangeValidationException(
      message: 'Value must be at least $min',
      field: field,
      minValue: min,
      actualValue: value,
    );
  }

  factory RangeValidationException.tooHigh({
    required dynamic value,
    required dynamic max,
    String? field,
  }) {
    return RangeValidationException(
      message: 'Value must be at most $max',
      field: field,
      maxValue: max,
      actualValue: value,
    );
  }
}