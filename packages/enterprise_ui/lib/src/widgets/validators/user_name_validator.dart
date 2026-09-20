import 'package:formz/formz.dart';

/// Validation error for [UserNameValidator].
enum UserNameValidationError {
  /// The field is empty.
  empty,

  /// The user name is too short.
  tooShort,
}

/// A user name validator.
class UserNameValidator extends FormzInput<String, UserNameValidationError> {
  /// Creates a [UserNameValidator] in a pure state.
  const UserNameValidator.pure() : super.pure('');

  /// Creates a [UserNameValidator] in a dirty state.
  const UserNameValidator.dirty([super.value = '']) : super.dirty();

  @override
  UserNameValidationError? validator(String value) {
    if (value.isEmpty) {
      return UserNameValidationError.empty;
    }
    return value.length > 1 ? null : UserNameValidationError.tooShort;
  }

  /// Localization key for [error], or `null` when [error] is `null`.
  ///
  /// Possible values:
  /// - `username_required`
  /// - `username_too_short`
  static String? getErrorMessage(UserNameValidationError? error) {
    return switch (error) {
      UserNameValidationError.empty => 'username_required',
      UserNameValidationError.tooShort =>
        'username_too_short',
      null => null,
    };
  }
}
