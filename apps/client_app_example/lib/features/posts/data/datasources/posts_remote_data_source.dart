import 'package:client_app_example/features/posts/data/models/post_model.dart';

/// Remote data source for posts.
abstract class PostsRemoteDataSource {
  /// Get a post by id.
  Future<PostModel> getPost(int id, {bool forceRefresh = false});

  /// Get a list of posts.
  Future<List<PostModel>> getPosts({int limit = 5});
}
