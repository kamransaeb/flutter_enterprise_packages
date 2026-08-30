import 'package:freezed_annotation/freezed_annotation.dart';

part 'token_refresh_request_model.freezed.dart';
part 'token_refresh_request_model.g.dart';

/// The model for the token refresh request.
@freezed
abstract class TokenRefreshRequestModel with _$TokenRefreshRequestModel {
  /// Creates a new [TokenRefreshRequestModel] instance.
  const factory TokenRefreshRequestModel({
    /// The refresh token to refresh.
    @JsonKey(name: 'refresh_token') required String refreshToken,
  }) = _TokenRefreshRequestModel;

  const TokenRefreshRequestModel._();

/// Creates a new [TokenRefreshRequestModel] instance from a JSON object.
  factory TokenRefreshRequestModel.fromJson(Map<String, dynamic> json) =>
    _$TokenRefreshRequestModelFromJson(json);

}
