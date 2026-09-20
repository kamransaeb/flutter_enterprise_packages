import 'package:formz/formz.dart';

/// Validation error for [UserSurnameValidator].
enum UserSurnameValidationError {
  /// The field is empty.
  empty,

  /// The surname is too short.
  tooShort,
}

/// A user surname validator.
class UserSurnameValidator
    extends FormzInput<String, UserSurnameValidationError> {
  /// Creates a [UserSurnameValidator] in a pure state.
  const UserSurnameValidator.pure() : super.pure('');

  /// Creates a [UserSurnameValidator] in a dirty state.
  const UserSurnameValidator.dirty([super.value = '']) : super.dirty();

  @override
  UserSurnameValidationError? validator(String value) {
    if (value.isEmpty) {
      return UserSurnameValidationError.empty;
    }
    return value.length > 1 ? null : UserSurnameValidationError.tooShort;
  }

  /// Human-readable message for [error].
  ///
  /// Possible values:
  /// - `surname_required`
  /// - `surname_too_short`
  static String? getErrorMessage(UserSurnameValidationError? error) {
    return switch (error) {
      UserSurnameValidationError.empty => 'surname_required',
      UserSurnameValidationError.tooShort => 'surname_too_short',
      null => null,
    };
  }
}
