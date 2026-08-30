import 'package:client_app_example/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:client_app_example/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:client_app_example/features/auth/domain/entities/auth_tokens.dart';
import 'package:client_app_example/features/auth/domain/entities/auth_user.dart';
import 'package:client_app_example/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:enterprise_core/enterprise_core.dart';
import 'package:injectable/injectable.dart';

/// The implementation of the [AuthRepository].
@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  /// Creates a new [AuthRepositoryImpl] instance.
  AuthRepositoryImpl(
    this._remote,
    this._local,
    this._errorHandler,
  );

  final AuthLocalDataSource _local;
  final AuthRemoteDataSource _remote;
  final ErrorHandler _errorHandler;

  @override
  Future<Either<Failure, AuthUser>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _remote.login(
        email: email,
        password: password,
      );
      await _local.cacheTokens(
        response.authTokens,
      );
      await _local.cacheUser(
        response.user,
      );
      return Right(response.user.toEntity());
    } on Object catch (e, stackStrace) {
      return Left(_errorHandler.handleError(e, stackTrace: stackStrace));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _remote.logout();
    } on Object catch (e, stackTrace) {
      // Still clear local session if network logout fails
      _errorHandler.handleError(e, stackTrace: stackTrace, reason: 'logout');
    }
    try {
      await _local.clearSession();
    } on Object catch (e, stackTrace) {
      return Left(
        _errorHandler.handleError(e, stackTrace: stackTrace, reason: 'logout'),
      );
    }
    return const Right(null);
  }

   @override
  Future<Either<Failure, AuthTokens>> refreshTokens() async {
    try {
      final cached = await _local.getCachedTokens();
      if (cached == null) {
        return Left(
          _errorHandler.handleError(
            Exception('No refresh token'),
            reason: 'refreshTokens',
          ),
        );
      }
      final response = await _remote.refreshToken(
        refreshToken: cached.refreshToken,
      );
      final tokens = response.toAuthTokensModel();
      await _local.cacheTokens(tokens);
      return Right(tokens.toEntity());
    } on Object catch (e, stackTrace) {
      return Left(
        _errorHandler.handleError(
          e,
          stackTrace: stackTrace,
          reason: 'refreshTokens',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, AuthUser?>> getCurrentUser() async {
    try {
      final cached = await _local.getCachedUser();
      if (cached != null) return Right(cached.toEntity());
      final remote = await _remote.currentUser();
      await _local.cacheUser(remote);
      return Right(remote.toEntity());
    } on Object catch (e, stackTrace) {
      return Left(
        _errorHandler.handleError(
          e,
          stackTrace: stackTrace,
          reason: 'getCurrentUser',
        ),
      );
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    final tokens = await _local.getCachedTokens();
    if (tokens == null) return false;
    return !tokens.toEntity().isExpired;
  }

}
