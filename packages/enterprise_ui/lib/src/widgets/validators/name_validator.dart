import 'package:formz/formz.dart';

/// Validation error for [NameValidator].
enum NameValidationError {
  /// The field is empty.
  empty,

  /// The name is too short.
  tooShort,
}

/// A name validator.
class NameValidator extends FormzInput<String, NameValidationError> {
  /// Creates a [NameValidator].
  const NameValidator.pure() : super.pure('');

  /// Creates a [NameValidator] in a dirty state.
  const NameValidator.dirty([super.value = '']) : super.dirty();

  @override
  NameValidationError? validator(String value) {
    if (value.isEmpty) {
      return NameValidationError.empty;
    }
    return value.length > 1 ? null : NameValidationError.tooShort;
  }

  /// Localization key for [error], or `null` when [error] is `null`.
  ///
  /// Possible values:
  /// - `name_required`
  /// - `name_too_short`
  static String? getErrorMessage(NameValidationError? error) {
    return switch (error) {
      NameValidationError.empty => 'name_required',
      NameValidationError.tooShort => 'name_too_short',
      null => null,
    };
  }
}
