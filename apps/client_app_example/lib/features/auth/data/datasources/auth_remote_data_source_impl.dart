import 'package:client_app_example/features/auth/data/api/auth_api_client.dart';
import 'package:client_app_example/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:client_app_example/features/auth/data/models/login_request_model.dart';
import 'package:client_app_example/features/auth/data/models/login_response_model.dart';
import 'package:client_app_example/features/auth/data/models/token_refresh_request_model.dart';
import 'package:client_app_example/features/auth/data/models/token_refresh_response_model.dart';
import 'package:client_app_example/features/auth/data/models/user_model.dart';
import 'package:injectable/injectable.dart';

/// The implementation of the [AuthRemoteDataSource].
@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  /// Creates a new [AuthRemoteDataSourceImpl] instance.
  AuthRemoteDataSourceImpl(
    this._authApi,
  );

  final AuthApiClient _authApi;

  @override
  Future<LoginResponseModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _authApi.login(
      body: LoginRequestModel(email: email, password: password),
    );
    return response.data;
  }

  @override
  Future<void> logout() async {
    await _authApi.logout();
  }

  @override
  Future<TokenRefreshResponseModel> refreshToken({
    required String refreshToken,
  }) async {
    final response = await _authApi.refreshToken(
      body: TokenRefreshRequestModel(
        refreshToken: refreshToken,
      ),
    );
    return response.data;
  }

  @override
  Future<UserModel> currentUser() async {
    final response = await _authApi.currentUser();
    return response.data;
  }
  
}
