import 'package:formz/formz.dart';

/// Validation error for [PriceValidator].
enum PriceValidationError {
  /// The field is empty.
  empty,

  /// The value is not a valid price.
  invalid,
}

/// A price validator.
class PriceValidator extends FormzInput<String, PriceValidationError> {
  /// Creates a [PriceValidator] in a pure state.
  const PriceValidator.pure() : super.pure('');

  /// Creates a [PriceValidator] in a dirty state.
  const PriceValidator.dirty([super.value = '']) : super.dirty();

  static final RegExp _priceRegExp = RegExp(
    r'^\d+((,\d+)+)?(.\d+)?(.\d+)?(,\d+)?',
  );

  @override
  PriceValidationError? validator(String value) {
    if (value.isEmpty) {
      return PriceValidationError.empty;
    }
    return _priceRegExp.hasMatch(value) ? null : PriceValidationError.invalid;
  }

  /// Localization key for [error], or `null` when [error] is `null`.
  ///
  /// Possible values:
  /// - `price_required`
  /// - `price_invalid`
  static String? getErrorMessage(PriceValidationError? error) {
    return switch (error) {
      PriceValidationError.empty => 'price_required',
      PriceValidationError.invalid => 'price_invalid',
      null => null,
    };
  }
}
