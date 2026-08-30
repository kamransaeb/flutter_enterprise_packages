part of 'login_bloc.dart';

/// The state for the login bloc.
@freezed
abstract class LoginState with _$LoginState {
  /// The constructor for the login state.
  const factory LoginState({
    @Default(Email.pure()) Email email,
    @Default(LoginPassword.pure()) LoginPassword password,
    @Default(FormzSubmissionStatus.initial) FormzSubmissionStatus status,
  }) = _LoginState;

  const LoginState._();

  /// Whether the login form is valid.
  bool get isValid => Formz.validate([email, password]);

  /// Whether to show errors.
  bool get showErrors => status == FormzSubmissionStatus.failure;
}
