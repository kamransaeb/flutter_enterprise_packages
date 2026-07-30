import 'package:formz/formz.dart';

enum PasswordValidationError {
  invalid,
  empty,
  tooShort,
  noUppercase,
  noLowercase,
  noDigit,
  noSpecialCharacter,
}

class Password extends FormzInput<String, PasswordValidationError> {
  const Password.pure() : super.pure('');
  const Password.dirty([String value = '']) : super.dirty(value);

  @override
  PasswordValidationError? validator(String value) {
    if (value.isEmpty) {
      return PasswordValidationError.empty;
    }
    if (value.length < 8) {
      return PasswordValidationError.tooShort;
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return PasswordValidationError.noUppercase;
    }
    if (!value.contains(RegExp(r'[a-z]'))) {
      return PasswordValidationError.noLowercase;
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return PasswordValidationError.noDigit;
    }
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return PasswordValidationError.noSpecialCharacter;
    }
    return null;
  }

  static String? getErrorMessage(PasswordValidationError? error) {
    switch (error) {
      case PasswordValidationError.empty:
        return 'Password is required';
      case PasswordValidationError.tooShort:
        return 'Password must be at least 8 characters';
      case PasswordValidationError.noUppercase:
        return 'Password must contain at least one uppercase letter';
      case PasswordValidationError.noLowercase:
        return 'Password must contain at least one lowercase letter';
      case PasswordValidationError.noDigit:
        return 'Password must contain at least one number';
      case PasswordValidationError.noSpecialCharacter:
        return 'Password must contain at least one special character';
      case PasswordValidationError.invalid:
        return 'Invalid password';
      default:
        return null;
    }
  }

  static String getValidationRules() {
    return '''
Password must contain:
• At least 8 characters
• At least one uppercase letter
• At least one lowercase letter
• At least one number
• At least one special character (!@#\$%^&*(),.?":{}|<>)
''';
  }
}