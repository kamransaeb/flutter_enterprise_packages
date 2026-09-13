import 'package:formz/formz.dart';

enum ConfirmedPasswordValidationError {
  invalid,
}

class ConfirmedPasswordInput extends FormzInput<String, ConfirmedPasswordValidationError> {

  final String originalPassword;

  const ConfirmedPasswordInput.pure({this.originalPassword = ''}) : super.pure('');

  const ConfirmedPasswordInput.dirty({required this.originalPassword, String value = ''}) : super.dirty(value);

  @override
  ConfirmedPasswordValidationError? validator(String value) {
    return  originalPassword == value ? null : ConfirmedPasswordValidationError.invalid;
  }

}