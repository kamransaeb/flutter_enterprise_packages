import 'package:client_app_example/features/auth/data/api/auth_endpoints.dart';
import 'package:client_app_example/features/auth/data/models/auth_tokens_model.dart';
import 'package:client_app_example/features/auth/data/models/login_request_model.dart';
import 'package:client_app_example/features/auth/data/models/login_response_model.dart';
import 'package:client_app_example/features/auth/data/models/token_refresh_request_model.dart';
import 'package:client_app_example/features/auth/data/models/token_refresh_response_model.dart';
import 'package:client_app_example/features/auth/data/models/user_model.dart';
// hide Headers avoids clashing with Retrofit’s Headers. That brings Options,
// Dio, RequestOptions, etc. into scope for the generated client.
import 'package:dio/dio.dart' hide Headers;
import 'package:enterprise_network/enterprise_network.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_api_client.g.dart';

/// The API client for the auth API.
@lazySingleton
@RestApi()
abstract class AuthApiClient {
  /// This is a factory method that will be used to create an instance of the
  ///  [AuthApiClient].
  @factoryMethod
  factory AuthApiClient(DioClient dioClient) => _AuthApiClient(dioClient.dio);

  /// This endpoint is public and does not require authentication.
  @POST(AuthEndpoints.login)
  @Extra({NetworkConstants.skipAuthExtraKey: true})
  Future<HttpResponse<LoginResponseModel>> login({
    @Body() required LoginRequestModel body,
  });

  /// This endpoint is protected and requires authentication.
  @POST(AuthEndpoints.logout)
  Future<HttpResponse<void>> logout();

  /// This endpoint is protected and requires authentication.
  @POST(AuthEndpoints.refreshToken)
  @Extra({
    NetworkConstants.skipAuthExtraKey: true,
    NetworkConstants.isRefreshCallExtraKey: true,
  })
  Future<HttpResponse<TokenRefreshResponseModel>>  refreshToken({
    @Body() required TokenRefreshRequestModel body,
  });

  /// This endpoint is protected and requires authentication.
  @GET(AuthEndpoints.currentUser)
  Future<HttpResponse<UserModel>> currentUser();

}
