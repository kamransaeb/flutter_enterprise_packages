// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LoginResponseModel _$LoginResponseModelFromJson(Map<String, dynamic> json) =>
    _LoginResponseModel(
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      authTokens: AuthTokensModel.fromJson(
        json['authTokens'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$LoginResponseModelToJson(_LoginResponseModel instance) =>
    <String, dynamic>{'user': instance.user, 'authTokens': instance.authTokens};
