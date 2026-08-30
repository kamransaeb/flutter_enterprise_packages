part of 'posts_bloc.dart';

/// Events for the [PostsBloc].
@freezed
abstract class PostsEvent with _$PostsEvent {
  const PostsEvent._();

  /// Emitted when the [PostsBloc] should load a single post.
  const factory PostsEvent.loadPost({
    @Default(1) int id,
    @Default(false) bool forceRefresh,
  }) = _EventLoadPost;

  /// Emitted when the [PostsBloc] should load a list of posts.
  const factory PostsEvent.loadPosts({
    @Default(5) int limit,
  }) = _EventLoadPosts;
}
