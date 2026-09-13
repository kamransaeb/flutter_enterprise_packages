import 'package:formz/formz.dart';

enum NameValidationError {
  invalid,
}

class NameInput extends FormzInput<String, NameValidationError> {

  const NameInput.pure() : super.pure('');

  const NameInput.dirty([super.value = '']) : super.dirty();

  // static final RegExp _nameRegExp = RegExp(
  //   r'/^[a-zA-Z]{3,}$/',
  // );

  @override
  NameValidationError? validator(String value) {
    return value.length > 1 ? null : NameValidationError.invalid;
  }
  
}