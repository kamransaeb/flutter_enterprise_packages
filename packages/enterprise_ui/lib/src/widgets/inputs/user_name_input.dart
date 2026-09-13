import 'package:formz/formz.dart';

/// Validation error for [UserNameInput].
enum UserNameValidationError {
  /// The user name is invalid.
  invalid,
}

/// A user name input.
class UserNameInput extends FormzInput<String, UserNameValidationError> {
  /// Creates a [UserNameInput] in a pure state.
  const UserNameInput.pure() : super.pure('');

  /// Creates a [UserNameInput] in a dirty state.
  const UserNameInput.dirty([super.value = '']) : super.dirty();

  // static final RegExp _nameRegExp = RegExp(
  //   r'/^[a-zA-Z]{3,}$/',
  // );

  @override
  UserNameValidationError? validator(String value) {
    return value.length > 1 ? null : UserNameValidationError.invalid;
    //return _nameRegExp.hasMatch(value ?? '') ? null :
    // DisplayNameValidationError.invalid;
  }
}
