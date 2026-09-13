import 'package:formz/formz.dart';

/// Validation error for [NameInput].
enum NameValidationError {
  /// The name is invalid.
  invalid,
}

/// A name input.
class NameInput extends FormzInput<String, NameValidationError> {
  /// Creates a [NameInput].
  const NameInput.pure() : super.pure('');

  /// Creates a [NameInput] in a dirty state.
  const NameInput.dirty([super.value = '']) : super.dirty();

  // static final RegExp _nameRegExp = RegExp(
  //   r'/^[a-zA-Z]{3,}$/',
  // );

  @override
  NameValidationError? validator(String value) {
    return value.length > 1 ? null : NameValidationError.invalid;
  }
}
