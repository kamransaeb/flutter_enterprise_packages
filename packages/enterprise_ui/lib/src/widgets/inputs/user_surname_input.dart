import 'package:formz/formz.dart';

enum UserSurnameValidationError {
  invalid,
}

class UserSurnameInput extends FormzInput<String, UserSurnameValidationError> {

  const UserSurnameInput.pure() : super.pure('');

  const UserSurnameInput.dirty([super.value = '']) : super.dirty();

  // static final RegExp _nameRegExp = RegExp(
  //   r'/^[a-zA-Z]{3,}$/',
  // );

  @override
  UserSurnameValidationError? validator(String value) {
    return value.length > 1 ? null : UserSurnameValidationError.invalid;
    //return _nameRegExp.hasMatch(value ?? '') ? null : DisplayNameValidationError.invalid;
  }
  
}