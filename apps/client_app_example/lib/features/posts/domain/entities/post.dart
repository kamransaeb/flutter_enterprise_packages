/// Entity for a post.
class Post {
  /// Constructor for a post.
  const Post({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  });

  /// The ID of the post.
  final int id;
  /// The ID of the user who wrote the post.
  final int userId;
  /// The title of the post.
  final String title;
  /// The body of the post.
  final String body;
}
