part of 'auth_bloc.dart';

/// The events for the authentication feature.
@freezed
abstract class AuthEvent with _$AuthEvent {
  const AuthEvent._();

  /// Checks whether a valid session exists and loads the current user when it 
  /// does.
  // = _EventCheckStatusRequested is Freezed syntax. It tells the generator:
  // “this factory builds the private class _EventCheckStatusRequested.”
  const factory AuthEvent.checkStatusRequested() = _EventCheckStatusRequested;

  /// Requests to login the user.
  const factory AuthEvent.loginRequested({
    required String email,
    required String password,
  }) = _EventLoginRequested;

  /// Requests to logout the user.
  const factory AuthEvent.logoutRequested() = _EventLogoutRequested;
}
