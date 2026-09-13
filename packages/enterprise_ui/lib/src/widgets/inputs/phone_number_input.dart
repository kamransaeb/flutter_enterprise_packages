import 'package:formz/formz.dart';

enum PhoneNumberValidationError {
  invalid,
}

class PhoneNumberInput extends FormzInput<String, PhoneNumberValidationError> {

  const PhoneNumberInput.pure() : super.pure('');

  const PhoneNumberInput.dirty([super.value = '']) : super.dirty();

  static final RegExp _phoneNumberRegExp =
  RegExp(r'^[0-9]+$',);

  @override
  PhoneNumberValidationError? validator(String? value) {
    return (_phoneNumberRegExp.hasMatch(value ?? '') && (value ?? '').length >= 9)
        ? null
        : PhoneNumberValidationError.invalid;
  }

  
}