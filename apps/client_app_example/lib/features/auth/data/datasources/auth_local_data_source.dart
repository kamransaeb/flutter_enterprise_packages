import 'package:client_app_example/features/auth/data/models/auth_tokens_model.dart';
import 'package:client_app_example/features/auth/data/models/user_model.dart';

/// The local data source for the auth API.
abstract class AuthLocalDataSource {

  /// Caches the tokens.
  Future<void> cacheTokens(AuthTokensModel tokens);

  /// Gets the cached tokens.
  Future<AuthTokensModel?> getCachedTokens();

  /// Clears the cached tokens.
  Future<void> clearCachedTokens();

  /// Caches the user.
  Future<void> cacheUser(UserModel user);

  /// Gets the cached user.
  Future<UserModel?> getCachedUser();

  /// Clears the cached user.
  Future<void> clearCachedUser();

  /// Clears the session.
  Future<void> clearSession();
}
