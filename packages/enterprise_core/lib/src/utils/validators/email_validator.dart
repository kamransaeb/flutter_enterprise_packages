import 'package:formz/formz.dart';

enum EmailValidationError {
  invalid,
  empty,
}

class Email extends FormzInput<String, EmailValidationError> {
  const Email.pure() : super.pure('');
  const Email.dirty([String value = '']) : super.dirty(value);

  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );

  @override
  EmailValidationError? validator(String value) {
    if (value.isEmpty) {
      return EmailValidationError.empty;
    }
    return _emailRegExp.hasMatch(value)
        ? null
        : EmailValidationError.invalid;
  }

  static String? getErrorMessage(EmailValidationError? error) {
    switch (error) {
      case EmailValidationError.empty:
        return 'Email is required';
      case EmailValidationError.invalid:
        return 'Please enter a valid email address';
      default:
        return null;
    }
  }
}