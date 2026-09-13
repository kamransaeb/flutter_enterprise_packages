import 'package:formz/formz.dart';

/// Validation error for [NumberInput].
enum NumberValidationError {
  /// The number is invalid.
  invalid,
}

/// A number input.
class NumberInput extends FormzInput<String, NumberValidationError> {
  /// Creates a [NumberInput].
  const NumberInput.pure() : super.pure('');

  /// Creates a [NumberInput] in a dirty state.
  const NumberInput.dirty([super.value = '']) : super.dirty();

  static final RegExp _numberRegExp = RegExp(
    r'^[0-9]+$',
  );

  @override
  NumberValidationError? validator(String? value) {
    return _numberRegExp.hasMatch(value ?? '')
        ? null
        : NumberValidationError.invalid;
  }
}
