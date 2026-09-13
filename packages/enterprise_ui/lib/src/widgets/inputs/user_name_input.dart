import 'package:formz/formz.dart';

enum UserNameValidationError {
  invalid,
}

class UserNameInput extends FormzInput<String, UserNameValidationError> {

  const UserNameInput.pure() : super.pure('');

  const UserNameInput.dirty([super.value = '']) : super.dirty();

  // static final RegExp _nameRegExp = RegExp(
  //   r'/^[a-zA-Z]{3,}$/',
  // );

  @override
  UserNameValidationError? validator(String value) {
    return value.length > 1 ? null : UserNameValidationError.invalid;
    //return _nameRegExp.hasMatch(value ?? '') ? null : DisplayNameValidationError.invalid;
  }
  
}