import 'package:formz/formz.dart';

/// Validation error for [ConfirmedPasswordValidator].
enum ConfirmedPasswordValidationError {
  /// The field is empty.
  empty,

  /// The confirmed password does not match the original password.
  mismatch,
}

/// A confirmed password validator.
class ConfirmedPasswordValidator
    extends FormzInput<String, ConfirmedPasswordValidationError> {
  /// Creates a [ConfirmedPasswordValidator].
  const ConfirmedPasswordValidator.pure({this.originalPassword = ''})
    : super.pure('');

  /// Creates a [ConfirmedPasswordValidator] in a dirty state.
  const ConfirmedPasswordValidator.dirty({
    required this.originalPassword,
    String value = '',
  }) : super.dirty(value);

  /// The original password.
  final String originalPassword;

  @override
  ConfirmedPasswordValidationError? validator(String value) {
    if (value.isEmpty) {
      return ConfirmedPasswordValidationError.empty;
    }
    return originalPassword == value
        ? null
        : ConfirmedPasswordValidationError.mismatch;
  }

  /// Localization key for [error], or `null` when [error] is `null`.
  ///
  /// Possible values:
  /// - `confirmed_password_required`
  /// - `passwords_do_not_match`
  static String? getErrorMessage(ConfirmedPasswordValidationError? error) {
    return switch (error) {
      ConfirmedPasswordValidationError.empty =>
        'confirmed_password_required',
      ConfirmedPasswordValidationError.mismatch => 'passwords_do_not_match',
      null => null,
    };
  }
}
