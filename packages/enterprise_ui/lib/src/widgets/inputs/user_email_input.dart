import 'package:formz/formz.dart';

enum UserEmailValidationError {
  invalid,
}

class UserEmailInput extends FormzInput<String, UserEmailValidationError> {

  const UserEmailInput.pure() : super.pure('');
  const UserEmailInput.dirty([super.value = '']) : super.dirty();

  static final RegExp _emailRegExp =
  RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  @override
  UserEmailValidationError? validator(String value) {
    return _emailRegExp.hasMatch(value ?? '') ? null : UserEmailValidationError.invalid;
  }

}