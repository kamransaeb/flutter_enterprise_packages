import 'package:client_app_example/features/auth/domain/entities/auth_user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// The model for the user.
@freezed
abstract class UserModel with _$UserModel {
  /// Creates a new [UserModel] instance.
  const factory UserModel({
    /// The id of the user.
    required String id,
    required String email,
    @JsonKey(name: 'first_name') String? firstName,
    @JsonKey(name: 'last_name') String? lastName,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'email_verified') bool? emailVerified,
  }) = _UserModel;

  const UserModel._();

  /// Creates a new [UserModel] instance from a JSON object.
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  /// Converts the [UserModel] to an [AuthUser].
  AuthUser toEntity() => AuthUser(
        id: id,
        email: email,
        firstName: firstName,
        lastName: lastName,
        avatarUrl: avatarUrl,
        emailVerified: emailVerified,
      );
}
