part of 'auth_bloc.dart';

/// The states for the authentication feature.
@freezed
abstract class AuthState with _$AuthState {
  const AuthState._();

  /// The initial state of the auth bloc.
  const factory AuthState.initial() = _StateInitial;

  /// The state of the auth bloc when checking the status of the user.
  const factory AuthState.checking() = _StateChecking;

  /// The state of the auth bloc when loading the user.
  const factory AuthState.loading() = _StateLoading;

  /// The state of the auth bloc when the user is authenticated.
  const factory AuthState.authenticated({required AuthUser authUser}) =
      _StateAuthenticated;

  /// The state of the auth bloc when the user is unauthenticated.
  const factory AuthState.unauthenticated() = _StateUnauthenticated;

  /// The state of the auth bloc when the user is failed to authenticate.
  const factory AuthState.failure({required Failure failure}) = _StateFailure;

  /// Whether the auth bloc is loading.
  bool get isLoading => maybeWhen(
    loading: () => true,
    checking: () => true,
    orElse: () => false,
  );

  /// The user of the auth bloc.
  AuthUser? get user => maybeWhen(
    authenticated: (user) => user,
    orElse: () => null,
  );

  /// Whether the auth bloc is authenticated.
  bool get isAuthenticated => maybeWhen(
    authenticated: (_) => true,
    orElse: () => false,
  );

  /// Whether the auth bloc is checking.
  bool get isChecking => maybeWhen(
    checking: () => true,
    orElse: () => false,
  );

}
