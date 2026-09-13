import 'package:formz/formz.dart';

/// Validation error for [UserPasswordInput].
enum UserPasswordValidationError {
  /// The password is invalid.
  invalid,
}

/// A user password input.
class UserPasswordInput
    extends FormzInput<String, UserPasswordValidationError> {
  /// Creates a [UserPasswordInput] in a pure state.
  const UserPasswordInput.pure() : super.pure('');

  /// Creates a [UserPasswordInput] in a dirty state.
  const UserPasswordInput.dirty([super.value = '']) : super.dirty();
  //const PasswordForm.dirty([String value = '']) : super.dirty(value);

  static final _passwordRegExp = RegExp(
    r'^.{6,}$',
  );

  @override
  UserPasswordValidationError? validator(String? value) {
    return _passwordRegExp.hasMatch(value ?? '')
        ? null
        : UserPasswordValidationError.invalid;
  }
}
