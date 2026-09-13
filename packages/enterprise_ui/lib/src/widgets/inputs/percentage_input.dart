import 'package:formz/formz.dart';

enum PercentageValidationError {
  invalid,
}

class PercentageInput extends FormzInput<String, PercentageValidationError> {

  const PercentageInput.pure() : super.pure('');

  const PercentageInput.dirty([super.value = '']) : super.dirty();

  static final RegExp _percentageRegExp =
  //RegExp(r'^\d+((,\d+)+)?(.\d+)?(.\d+)?(,\d+)?');
  RegExp(r'(^\d*\.?\d*)');

  @override
  PercentageValidationError? validator(String? value) {
    return (value == null || value.isEmpty) ? PercentageValidationError.invalid :
    _percentageRegExp.hasMatch(value) && (double.parse(value) < 100)
        ? null
        : PercentageValidationError.invalid;
  }
  
}