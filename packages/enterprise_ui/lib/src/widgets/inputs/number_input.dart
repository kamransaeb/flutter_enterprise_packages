import 'package:formz/formz.dart';

enum NumberValidationError {
  invalid,
}

class NumberInput extends FormzInput<String, NumberValidationError> {

  const NumberInput.pure() : super.pure('');

  const NumberInput.dirty([super.value = '']) : super.dirty();

  static final RegExp _numberRegExp =
  RegExp(r'^[0-9]+$',);

  @override
  NumberValidationError? validator(String? value) {
    return _numberRegExp.hasMatch(value ?? '')
        ? null
        : NumberValidationError.invalid;
  }
  
}