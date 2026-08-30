import 'package:client_app_example/features/auth/domain/entities/auth_tokens.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'auth_tokens_model.freezed.dart';
part 'auth_tokens_model.g.dart';

/// The model for the auth tokens.
@freezed
abstract class AuthTokensModel with _$AuthTokensModel {
  /// Creates a new [AuthTokensModel] instance.
  const factory AuthTokensModel({
    @JsonKey(name: 'access_token') required String accessToken,
    @JsonKey(name: 'refresh_token') required String refreshToken,
    @JsonKey(name: 'expires_at') required DateTime expiresAt,
  }) = _AuthTokensModel;

  // Without this, the freezed library will not generate the instance methods 
  // like fromJson and toJson and toEntity.
  // This is a required part of the freezed library.
  // The abstract class has no fields,
  // the mixin adds getters only when this private constructor exists.
  const AuthTokensModel._();

  /// Creates a new [AuthTokensModel] instance from a JSON object.
  factory AuthTokensModel.fromJson(Map<String, dynamic> json) =>
      _$AuthTokensModelFromJson(json);

  /// Converts the [AuthTokensModel] to an [AuthTokens].
  AuthTokens toEntity() => AuthTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
        expiresAt: expiresAt,
      );
}
