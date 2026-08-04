import 'package:flutter_enterprise_boilerplate/features/auth/data/models/user_model.dart';
import 'package:hive/hive.dart';
import 'package:flutter_enterprise_boilerplate/features/auth/domain/entities/user.dart';

class UserAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 1;

  @override
  UserModel read(BinaryReader reader) {

    final id = reader.readString();
    final email = reader.readString();
    final firstName = reader.readString();
    final lastName = reader.readString();
    final avatarUrl = reader.readString();
    final phoneNumber = reader.readString();
    final emailVerified = reader.readBool();
    final roles = reader.readList().cast<String>();
    
    final hasCreatedAt = reader.readBool();
    final createdAt = hasCreatedAt ? DateTime.fromMillisecondsSinceEpoch(reader.readInt()) : null;
    
    final hasUpdatedAt = reader.readBool();
    final updatedAt = hasUpdatedAt ? DateTime.fromMillisecondsSinceEpoch(reader.readInt()) : null;

    final hasLoggedInAt = reader.readBool();
    final loggedInAt = hasLoggedInAt ? DateTime.fromMillisecondsSinceEpoch(reader.readInt()) : null;

    final isProfileCompleted = reader.readBool();
     
    return UserModel(
      id: id,
      email: email,
      firstName: firstName,
      lastName: lastName,
      avatarUrl: avatarUrl.isEmpty ? null : avatarUrl,
      phoneNumber: phoneNumber.isEmpty ? null : phoneNumber,
      emailVerified: emailVerified,
      roles: roles,
      createdAt: createdAt,
      updatedAt: updatedAt,
      loggedInAt: loggedInAt,
      isProfileCompleted: isProfileCompleted,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel userModel) {
    writer
      ..writeString(userModel.id)
      ..writeString(userModel.email)
      ..writeString(userModel.firstName ?? '')
      ..writeString(userModel.lastName ?? '')
      ..writeString(userModel.avatarUrl ?? '')
      ..writeString(userModel.phoneNumber ?? '')
      ..writeBool(userModel.emailVerified ?? false)
      ..writeList(userModel.roles ?? [])
      ..writeBool(userModel.createdAt != null);

      if (userModel.createdAt != null) {
        writer.writeInt(userModel.createdAt!.millisecondsSinceEpoch);
      }

      writer.writeBool(userModel.updatedAt != null);
      if (userModel.updatedAt != null) {
        writer.writeInt(userModel.updatedAt!.millisecondsSinceEpoch);
      }

      writer.writeBool(userModel.loggedInAt != null);
      if (userModel.loggedInAt != null) {
        writer.writeInt(userModel.loggedInAt!.millisecondsSinceEpoch);
      }

      writer.writeBool(userModel.isProfileCompleted ?? false);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
