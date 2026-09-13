import 'package:formz/formz.dart';

/// Validation error for [UserSurnameInput].
enum UserSurnameValidationError {
  /// The user surname is invalid.
  invalid,
}

/// A user surname input.
class UserSurnameInput extends FormzInput<String, UserSurnameValidationError> {
  /// Creates a [UserSurnameInput] in a pure state.
  const UserSurnameInput.pure() : super.pure('');

  /// Creates a [UserSurnameInput] in a dirty state.
  const UserSurnameInput.dirty([super.value = '']) : super.dirty();

  // static final RegExp _nameRegExp = RegExp(
  //   r'/^[a-zA-Z]{3,}$/',
  // );

  @override
  UserSurnameValidationError? validator(String value) {
    return value.length > 1 ? null : UserSurnameValidationError.invalid;
    //return _nameRegExp.hasMatch(value ?? '') ? null :
    // DisplayNameValidationError.invalid;
  }
}
