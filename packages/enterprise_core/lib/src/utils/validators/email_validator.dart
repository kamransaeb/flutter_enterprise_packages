import 'package:formz/formz.dart';

/// Email validation error.
enum EmailValidationError {
  /// Invalid.
  invalid,

  /// Empty.
  empty,
}

/// Email.
class Email extends FormzInput<String, EmailValidationError> {
  /// Pure.
  const Email.pure() : super.pure('');

  /// Dirty.
  const Email.dirty([super.value = '']) : super.dirty();

  static final RegExp _emailRegExp = RegExp(
    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$",
  );

  /// Validator.
  @override
  EmailValidationError? validator(String value) {
    if (value.isEmpty) {
      return EmailValidationError.empty;
    }
    return _emailRegExp.hasMatch(value) ? null : EmailValidationError.invalid;
  }

  /// Get error message.
  static String? getErrorMessage(EmailValidationError? error) {
    return switch (error) {
      EmailValidationError.empty => 'email is required',
      EmailValidationError.invalid => 'Please enter a valid email address',
      null => null,
    };
  }
}
