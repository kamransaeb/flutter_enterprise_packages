import 'package:client_app_example/features/auth/data/models/auth_tokens_model.dart';
import 'package:client_app_example/features/auth/domain/entities/auth_tokens.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'token_refresh_response_model.freezed.dart';
part 'token_refresh_response_model.g.dart';

/// The model for the token refresh response.
@freezed
abstract class TokenRefreshResponseModel with _$TokenRefreshResponseModel {
  /// Creates a new [TokenRefreshResponseModel] instance.
  const factory TokenRefreshResponseModel({
    /// The refresh token to refresh.
    @JsonKey(name: 'access_token') required String accessToken,
    @JsonKey(name: 'refresh_token') required String refreshToken,
    @JsonKey(name: 'expires_at') required DateTime expiresAt,
  }) = _TokenRefreshResponseModel;

  const TokenRefreshResponseModel._();

  /// Creates a new [TokenRefreshResponseModel] instance from a JSON object.
  factory TokenRefreshResponseModel.fromJson(Map<String, dynamic> json) =>
      _$TokenRefreshResponseModelFromJson(json);

  /// Converts the [TokenRefreshResponseModel] to an [AuthTokensModel].
  AuthTokensModel toAuthTokensModel() => AuthTokensModel(
    accessToken: accessToken,
    refreshToken: refreshToken,
    expiresAt: expiresAt,
  );

  /// Converts the [TokenRefreshResponseModel] to an [AuthTokens].
  AuthTokens toAuthTokensEntity() => AuthTokens(
    accessToken: accessToken,
    refreshToken: refreshToken,
    expiresAt: expiresAt,
  );
}
