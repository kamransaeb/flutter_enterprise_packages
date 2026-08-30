import 'package:formz/formz.dart';

/// Validation error for email validator
enum EmailValidationError {
  /// Invalid error
  invalid,
  /// Empty error
  empty,
}

/// Email validator
class Email extends FormzInput<String, EmailValidationError> {
  /// Pure constructor
  const Email.pure() : super.pure('');

  /// Dirty constructor
  const Email.dirty([super.value = '']) : super.dirty();

  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );

  @override
  EmailValidationError? validator(String value) {
    if (value.isEmpty) {
      return EmailValidationError.empty;
    }
    return _emailRegExp.hasMatch(value) ? null : EmailValidationError.invalid;
  }

  /// Get error message
  static String? getErrorMessage(EmailValidationError? error) {
    return switch (error) {
      EmailValidationError.empty => 'Email is required',
      EmailValidationError.invalid => 'Please enter a valid email address',
      null => null,
    };
  }
}
