import 'package:freezed_annotation/freezed_annotation.dart';
part 'login_request_model.freezed.dart';
part 'login_request_model.g.dart';

/// The request model for the login endpoint.
@freezed
abstract class LoginRequestModel with _$LoginRequestModel {
  /// Creates a new [LoginRequestModel] instance.
  const factory LoginRequestModel({
    required String email,
    required String password,
  }) = _LoginRequestModel;

  const LoginRequestModel._();

  /// Creates a new [LoginRequestModel] instance from a JSON object.
  factory LoginRequestModel.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestModelFromJson(json);

}
