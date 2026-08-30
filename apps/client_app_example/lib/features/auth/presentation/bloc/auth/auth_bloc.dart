import 'package:client_app_example/features/auth/domain/entities/auth_user.dart';
import 'package:client_app_example/features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'package:client_app_example/features/auth/domain/usecases/login_usecase.dart';
import 'package:client_app_example/features/auth/domain/usecases/logout_usecase.dart';
import 'package:enterprise_core/enterprise_core.dart';
import 'package:enterprise_logger/enterprise_logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'auth_bloc.freezed.dart';
part 'auth_event.dart';
part 'auth_state.dart';

/// The bloc for the authentication feature.
/// It uses the [AuthState] and [AuthEvent] classes to manage the state and
/// events.
@lazySingleton
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  /// Creates a new [AuthBloc] instance.
  AuthBloc(
    this._loginUseCase,
    this._logoutUseCase,
    this._checkAuthStatusUseCase,
    this._logger,
  ) : super(const AuthState.initial()) {
    on<_EventCheckStatusRequested>(_onCheckStatusRequested);
    on<_EventLoginRequested>(_onLoginRequested);
    on<_EventLogoutRequested>(_onLogoutRequested);
  }

  final CheckAuthStatusUseCase _checkAuthStatusUseCase;
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final LoggerService _logger;

  Future<void> _onCheckStatusRequested(
    _EventCheckStatusRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.checking());
    try {
      final result = await _checkAuthStatusUseCase(const NoParams());
      result.fold(
        (failure) => emit(AuthState.failure(failure: failure)),
        (authUser) {
          if (authUser == null) {
            emit(const AuthState.unauthenticated());
          } else {
            emit(AuthState.authenticated(authUser: authUser));
          }
        },
      );
    } on Object catch (e, stackTrace) {
      _logger.e('Error checking auth status', error: e, stackTrace: stackTrace);
      emit(const AuthState.unauthenticated());
    }
  }

  Future<void> _onLoginRequested(
    _EventLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    final result = await _loginUseCase(
      LoginParams(email: event.email, password: event.password),
    );
    result.fold(
      (failure) => emit(AuthState.failure(failure: failure)),
      (authUser) => emit(AuthState.authenticated(authUser: authUser)),
    );
  }

  Future<void> _onLogoutRequested(
    _EventLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    final result = await _logoutUseCase(const NoParams());
    result.fold(
      (failure) => emit(AuthState.failure(failure: failure)),
      (_) => emit(const AuthState.unauthenticated()),
    );
  }
}
