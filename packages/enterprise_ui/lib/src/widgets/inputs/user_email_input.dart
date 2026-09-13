import 'package:formz/formz.dart';

/// Validation error for [UserEmailInput].
enum UserEmailValidationError {
  /// The email is invalid.
  invalid,
}

/// A user email input.
class UserEmailInput extends FormzInput<String, UserEmailValidationError> {
  /// Creates a [UserEmailInput] in a pure state.
  const UserEmailInput.pure() : super.pure('');

  /// Creates a [UserEmailInput] in a dirty state.
  const UserEmailInput.dirty([super.value = '']) : super.dirty();

  static final RegExp _emailRegExp = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );

  @override
  UserEmailValidationError? validator(String? value) {
    return _emailRegExp.hasMatch(value ?? '')
        ? null
        : UserEmailValidationError.invalid;
  }
}
