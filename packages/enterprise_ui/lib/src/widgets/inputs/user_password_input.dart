import 'package:formz/formz.dart';

enum UserPasswordValidationError {
  invalid,
}

class UserPasswordInput extends FormzInput<String, UserPasswordValidationError> {

  const UserPasswordInput.pure() : super.pure('');

  const UserPasswordInput.dirty([super.value = '']) : super.dirty();
  //const PasswordForm.dirty([String value = '']) : super.dirty(value);

  static final _passwordRegExp =
  RegExp(r'^.{6,}$',);

  @override
  UserPasswordValidationError? validator(String? value) {
    return _passwordRegExp.hasMatch(value ?? '')
        ? null
        : UserPasswordValidationError.invalid;
  }

}