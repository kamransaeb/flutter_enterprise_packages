part of 'posts_bloc.dart';

/// States for the [PostsBloc].
@freezed
abstract class PostsState with _$PostsState {
  const PostsState._();

  /// The initial state of the [PostsBloc].
  const factory PostsState.initial() = _Initial;

  /// The state of the [PostsBloc] when it is loading.
  const factory PostsState.loading() = _Loading;

  /// The state of the [PostsBloc] when it has loaded the posts.
  const factory PostsState.loaded({
    Post? post,
    @Default(<Post>[]) List<Post> posts,
  }) = _Loaded;

  /// The state of the [PostsBloc] when it has encountered an error.
  const factory PostsState.error(Failure failure) = _Error;
}
