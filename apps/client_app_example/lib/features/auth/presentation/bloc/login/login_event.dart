part of 'login_bloc.dart';

/// The event for the login bloc.
@freezed
abstract class LoginEvent with _$LoginEvent {
  /// The event for the email changed.
  const factory LoginEvent.emailChanged(String email) = _EventEmailChanged;

  /// The event for the password changed.
  const factory LoginEvent.passwordChanged(String password) =
      _EventPasswordChanged;

  /// The event for the submitted.
  const factory LoginEvent.submitted() = _EventSubmitted;

  /// The event for the reset.
  const factory LoginEvent.reset() = _EventReset;

  /// The event for the auth failed.
  const factory LoginEvent.authFailed() = _EventAuthFailed;
}
