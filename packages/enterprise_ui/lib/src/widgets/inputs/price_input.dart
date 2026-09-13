import 'package:formz/formz.dart';

/// Validation error for [PriceInput].
enum PriceValidationError {
  /// The price is invalid.
  invalid,
}

/// A price input.
class PriceInput extends FormzInput<String, PriceValidationError> {
  /// Creates a [PriceInput] in a pure state.
  const PriceInput.pure() : super.pure('');

  /// Creates a [PriceInput] in a dirty state.
  const PriceInput.dirty([super.value = '']) : super.dirty();

  static final RegExp _priceRegExp = RegExp(
    r'^\d+((,\d+)+)?(.\d+)?(.\d+)?(,\d+)?',
  );

  @override
  PriceValidationError? validator(String? value) {
    return _priceRegExp.hasMatch(value ?? '')
        ? null
        : PriceValidationError.invalid;
  }
}
