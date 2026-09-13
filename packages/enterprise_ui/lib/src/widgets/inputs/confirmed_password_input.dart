import 'package:formz/formz.dart';

/// Validation error for [ConfirmedPasswordInput].
enum ConfirmedPasswordValidationError {
  /// The confirmed password does not match the original password.
  invalid,
}

/// A confirmed password input.
class ConfirmedPasswordInput
    extends FormzInput<String, ConfirmedPasswordValidationError> {
  /// Creates a [ConfirmedPasswordInput].
  const ConfirmedPasswordInput.pure({this.originalPassword = ''})
    : super.pure('');

  /// Creates a [ConfirmedPasswordInput] in a dirty state.
  const ConfirmedPasswordInput.dirty({
    required this.originalPassword,
    String value = '',
  }) : super.dirty(value);

  /// The original password.
  final String originalPassword;

  @override
  ConfirmedPasswordValidationError? validator(String value) {
    return originalPassword == value
        ? null
        : ConfirmedPasswordValidationError.invalid;
  }
}
