import 'package:formz/formz.dart';

/// Validation error for email validator
enum LoginPasswordValidationError { 
  /// Empty error
  empty,
  }

/// Login password validator
class LoginPassword extends FormzInput<String, LoginPasswordValidationError> {

  /// Pure constructor
  const LoginPassword.pure() : super.pure('');
  /// Dirty constructor
  const LoginPassword.dirty([super.value = '']) : super.dirty();


  @override
  LoginPasswordValidationError? validator(String value) {
    if (value.isEmpty) return LoginPasswordValidationError.empty;
    return null;
  }

  /// Get error message
  static String? getErrorMessage(LoginPasswordValidationError? error) {
    return switch (error) {
      LoginPasswordValidationError.empty => 'Password is required',
      null => null,
    };
  }
}
