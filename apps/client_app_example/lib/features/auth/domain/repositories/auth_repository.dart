import 'package:client_app_example/features/auth/domain/entities/auth_tokens.dart';
import 'package:client_app_example/features/auth/domain/entities/auth_user.dart';
import 'package:dartz/dartz.dart';
import 'package:enterprise_core/enterprise_core.dart';

/// The repository for the authentication service.
abstract class AuthRepository {
  /// Logs in a user.
  Future<Either<Failure, AuthUser>> login({
    required String email,
    required String password,
  });

  /// Logs out a user.
  Future<Either<Failure, void>> logout();

  /// Refreshes the authentication tokens.
  Future<Either<Failure, AuthTokens>> refreshTokens();

  /// Gets the current user.
  Future<Either<Failure, AuthUser?>> getCurrentUser();

  /// Checks if the user is authenticated.
  Future<bool> isAuthenticated();
}
