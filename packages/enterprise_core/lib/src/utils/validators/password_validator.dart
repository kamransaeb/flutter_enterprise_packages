import 'package:formz/formz.dart';

/// Password validation error.
enum PasswordValidationError {
  /// Invalid.
  invalid,

  /// Empty.
  empty,

  /// Too short.
  tooShort,

  /// No uppercase.
  noUppercase,

  /// No lowercase.
  noLowercase,

  /// No digit.
  noDigit,

  /// No special character.
  noSpecialCharacter,
}

/// Password.
class Password extends FormzInput<String, PasswordValidationError> {
  /// Pure.
  const Password.pure() : super.pure('');

  /// Dirty.
  const Password.dirty([super.value = '']) : super.dirty();

  /// Validator.
  @override
  PasswordValidationError? validator(String value) {
    if (value.isEmpty) {
      return PasswordValidationError.empty;
    }
    if (value.length < 8) {
      return PasswordValidationError.tooShort;
    }
    if (!value.contains(RegExp('[A-Z]'))) {
      return PasswordValidationError.noUppercase;
    }
    if (!value.contains(RegExp('[a-z]'))) {
      return PasswordValidationError.noLowercase;
    }
    if (!value.contains(RegExp('[0-9]'))) {
      return PasswordValidationError.noDigit;
    }
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return PasswordValidationError.noSpecialCharacter;
    }
    return null;
  }

  /// Get error message.
  static String? getErrorMessage(PasswordValidationError? error) {
    return switch (error) {
      PasswordValidationError.empty => 'Password is required',
      PasswordValidationError.tooShort =>
        'Password must be at least 8 characters',
      PasswordValidationError.noUppercase =>
        'Password must contain at least one uppercase letter',
      PasswordValidationError.noLowercase =>
        'Password must contain at least one lowercase letter',
      PasswordValidationError.noDigit =>
        'Password must contain at least one number',
      PasswordValidationError.noSpecialCharacter =>
        'Password must contain at least one special character',
      PasswordValidationError.invalid => 'Invalid password',
      null => null,
    };
  }

  /// Get validation rules.
  static String getValidationRules() {
    return r'''
Password must contain:
• At least 8 characters
• At least one uppercase letter
• At least one lowercase letter
• At least one number
• At least one special character (!@#$%^&*(),.?":{}|<>)
''';
  }
}
