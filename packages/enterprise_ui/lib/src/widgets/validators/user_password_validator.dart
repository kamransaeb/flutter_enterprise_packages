import 'package:formz/formz.dart';

/// Validation error for [UserPasswordValidator].
enum UserPasswordValidationError {
  /// The field is empty.
  empty,

  /// The password is too short.
  tooShort,
}

/// A user password validator.
class UserPasswordValidator
    extends FormzInput<String, UserPasswordValidationError> {
  /// Creates a [UserPasswordValidator] in a pure state.
  const UserPasswordValidator.pure() : super.pure('');

  /// Creates a [UserPasswordValidator] in a dirty state.
  const UserPasswordValidator.dirty([super.value = '']) : super.dirty();

  static const int _minLength = 6;

  @override
  UserPasswordValidationError? validator(String value) {
    if (value.isEmpty) {
      return UserPasswordValidationError.empty;
    }
    return value.length >= _minLength
        ? null
        : UserPasswordValidationError.tooShort;
  }

  /// Localization key for [error], or `null` when [error] is `null`.
  ///
  /// Possible values:
  /// - `password_required`
  /// - `password_too_short`
  static String? getErrorMessage(UserPasswordValidationError? error) {
    return switch (error) {
      UserPasswordValidationError.empty => 'password_required',
      UserPasswordValidationError.tooShort =>
        'password_too_short',
      null => null,
    };
  }
}
