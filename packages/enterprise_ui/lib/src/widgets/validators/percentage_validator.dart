import 'package:formz/formz.dart';

/// Validation error for [PercentageValidator].
enum PercentageValidationError {
  /// The field is empty.
  empty,

  /// The value is not a valid percentage number.
  invalid,

  /// The value is 100 or greater.
  tooHigh,
}

/// A percentage validator.
class PercentageValidator
    extends FormzInput<String, PercentageValidationError> {
  /// Creates a [PercentageValidator].
  const PercentageValidator.pure() : super.pure('');

  /// Creates a [PercentageValidator] in a dirty state.
  const PercentageValidator.dirty([super.value = '']) : super.dirty();

  static final RegExp _percentageRegExp = RegExp(r'^\d*\.?\d+$');

  @override
  PercentageValidationError? validator(String value) {
    if (value.isEmpty) {
      return PercentageValidationError.empty;
    }
    if (!_percentageRegExp.hasMatch(value)) {
      return PercentageValidationError.invalid;
    }
    final parsed = double.tryParse(value);
    if (parsed == null) {
      return PercentageValidationError.invalid;
    }
    if (parsed >= 100) {
      return PercentageValidationError.tooHigh;
    }
    return null;
  }

  /// Localization key for [error], or `null` when [error] is `null`.
  ///
  /// Possible values:
  /// - `percentage_required`
  /// - `percentage_invalid`
  /// - `percentage_too_high`
  static String? getErrorMessage(PercentageValidationError? error) {
    return switch (error) {
      PercentageValidationError.empty => 'percentage_required',
      PercentageValidationError.invalid => 'percentage_invalid',
      PercentageValidationError.tooHigh => 'percentage_too_high',
      null => null,
    };
  }
}
