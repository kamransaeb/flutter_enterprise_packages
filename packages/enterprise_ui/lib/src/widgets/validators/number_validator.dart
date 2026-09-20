import 'package:formz/formz.dart';

/// Validation error for [NumberValidator].
enum NumberValidationError {
  /// The field is empty.
  empty,

  /// The value is not a valid number.
  invalid,
}

/// A number validator.
class NumberValidator extends FormzInput<String, NumberValidationError> {
  /// Creates a [NumberValidator].
  const NumberValidator.pure() : super.pure('');

  /// Creates a [NumberValidator] in a dirty state.
  const NumberValidator.dirty([super.value = '']) : super.dirty();

  static final RegExp _numberRegExp = RegExp(r'^[0-9]+$');

  @override
  NumberValidationError? validator(String value) {
    if (value.isEmpty) {
      return NumberValidationError.empty;
    }
    return _numberRegExp.hasMatch(value)
        ? null
        : NumberValidationError.invalid;
  }

  /// Localization key for [error], or `null` when [error] is `null`.
  ///
  /// Possible values:
  /// - `number_required`
  /// - `number_invalid`
  static String? getErrorMessage(NumberValidationError? error) {
    return switch (error) {
      NumberValidationError.empty => 'number_required',
      NumberValidationError.invalid => 'number_invalid',
      null => null,
    };
  }
}
