import 'package:formz/formz.dart';

/// Validation error for [PercentageInput].
enum PercentageValidationError {
  /// The percentage is invalid.
  invalid,
}

/// A percentage input.
class PercentageInput extends FormzInput<String, PercentageValidationError> {
  /// Creates a [PercentageInput].
  const PercentageInput.pure() : super.pure('');

  /// Creates a [PercentageInput] in a dirty state.
  const PercentageInput.dirty([super.value = '']) : super.dirty();

  static final RegExp _percentageRegExp =
      //RegExp(r'^\d+((,\d+)+)?(.\d+)?(.\d+)?(,\d+)?');
      RegExp(r'(^\d*\.?\d*)');

  @override
  PercentageValidationError? validator(String? value) {
    return (value == null || value.isEmpty)
        ? PercentageValidationError.invalid
        : _percentageRegExp.hasMatch(value) && (double.parse(value) < 100)
        ? null
        : PercentageValidationError.invalid;
  }
}
