import 'package:formz/formz.dart';

enum PriceValidationError {
  invalid,
}

class PriceInput extends FormzInput<String, PriceValidationError> {

  const PriceInput.pure() : super.pure('');

  const PriceInput.dirty([super.value = '']) : super.dirty();

  static final RegExp _priceRegExp =
  RegExp(r'^\d+((,\d+)+)?(.\d+)?(.\d+)?(,\d+)?');

  @override
  PriceValidationError? validator(String? value) {
    return _priceRegExp.hasMatch(value ?? '')
        ? null
        : PriceValidationError.invalid;
  }
  
}