
import 'package:client_app_example/features/auth/data/models/auth_tokens_model.dart';
import 'package:client_app_example/features/auth/data/models/user_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_response_model.freezed.dart';
part 'login_response_model.g.dart';

/// Represents the response from the login endpoint.
@freezed
abstract class LoginResponseModel with _$LoginResponseModel {
  /// The user associated with the login.
  const factory LoginResponseModel({
    required UserModel user,
    required AuthTokensModel authTokens,   
  }) = _LoginResponseModel;

  const LoginResponseModel._();

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
    _$LoginResponseModelFromJson(json);
}
