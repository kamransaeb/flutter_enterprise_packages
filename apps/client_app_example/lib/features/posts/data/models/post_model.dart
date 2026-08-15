import 'package:client_app_example/features/posts/domain/entities/post.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post_model.g.dart';

/// Serializable model
@JsonSerializable()
class PostModel {
  /// Constructor
  const PostModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  });

  /// JSON constructor
  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);

  /// ID
  final int id;
  /// User ID
  final int userId;
  /// Title
  final String title;
  /// Body
  final String body;

  /// To JSON
  Map<String, dynamic> toJson() => _$PostModelToJson(this);

  /// To entity
  Post toEntity() => Post(
      id: id,
      userId: userId,
      title: title,
      body: body,
    );
}
