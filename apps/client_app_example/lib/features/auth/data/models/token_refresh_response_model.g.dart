// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_refresh_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TokenRefreshResponseModel _$TokenRefreshResponseModelFromJson(
  Map<String, dynamic> json,
) => _TokenRefreshResponseModel(
  accessToken: json['access_token'] as String,
  refreshToken: json['refresh_token'] as String,
  expiresAt: DateTime.parse(json['expires_at'] as String),
);

Map<String, dynamic> _$TokenRefreshResponseModelToJson(
  _TokenRefreshResponseModel instance,
) => <String, dynamic>{
  'access_token': instance.accessToken,
  'refresh_token': instance.refreshToken,
  'expires_at': instance.expiresAt.toIso8601String(),
};
