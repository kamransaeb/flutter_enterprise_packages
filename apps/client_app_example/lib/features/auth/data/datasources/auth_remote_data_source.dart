import 'package:client_app_example/features/auth/data/models/login_response_model.dart';
import 'package:client_app_example/features/auth/data/models/token_refresh_response_model.dart';
import 'package:client_app_example/features/auth/data/models/user_model.dart';

/// The remote data source for the auth API.
abstract class AuthRemoteDataSource {
  /// Logs in a user.
  Future<LoginResponseModel> login({
    required String email,
    required String password,
    });

    /// Logs out a user.
    Future<void> logout();

    /// Refreshes a token.
    Future<TokenRefreshResponseModel> refreshToken({
      required String refreshToken,
    });

    /// Gets the current user.
    Future<UserModel> currentUser();
}
