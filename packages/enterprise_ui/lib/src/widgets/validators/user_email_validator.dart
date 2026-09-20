import 'package:formz/formz.dart';

/// Validation error for [UserEmailValidator].
enum UserEmailValidationError {
  /// The field is empty.
  empty,

  /// The email format is invalid.
  invalid,
}

/// A user email validator.
class UserEmailValidator extends FormzInput<String, UserEmailValidationError> {
  /// Creates a [UserEmailValidator] in a pure state.
  const UserEmailValidator.pure() : super.pure('');

  /// Creates a [UserEmailValidator] in a dirty state.
  const UserEmailValidator.dirty([super.value = '']) : super.dirty();

  static final RegExp _emailRegExp = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );

  @override
  UserEmailValidationError? validator(String value) {
    if (value.isEmpty) {
      return UserEmailValidationError.empty;
    }
    return _emailRegExp.hasMatch(value)
        ? null
        : UserEmailValidationError.invalid;
  }

  /// Localization key for [error], or `null` when [error] is `null`.
  ///
  /// Possible values:
  /// - `email_required`
  /// - `email_invalid`
  static String? getErrorMessage(UserEmailValidationError? error) {
    return switch (error) {
      UserEmailValidationError.empty => 'email_required',
      UserEmailValidationError.invalid =>
        'email_invalid',
      null => null,
    };
  }
}
