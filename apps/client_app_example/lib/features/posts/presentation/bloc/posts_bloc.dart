import 'package:client_app_example/features/posts/domain/entities/post.dart';
import 'package:client_app_example/features/posts/domain/usecases/get_post_usecase.dart';
import 'package:client_app_example/features/posts/domain/usecases/get_posts_usecase.dart';
import 'package:enterprise_core/enterprise_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'posts_event.dart';
part 'posts_state.dart';
part 'posts_bloc.freezed.dart';

/// Owns the state of the posts and the usecases to load them.
@injectable
class PostsBloc extends Bloc<PostsEvent, PostsState> {
  /// Creates a [PostsBloc].
  PostsBloc(
    this._getPost,
    this._getPosts,
  ) : super(const PostsState.initial()) {
    on<_EventLoadPost>(_onLoadPost);
    on<_EventLoadPosts>(_onLoadPosts);
  }

  final GetPostUseCase _getPost;
  final GetPostsUseCase _getPosts;

  Future<void> _onLoadPost(
    _EventLoadPost event,
    Emitter<PostsState> emit,
  ) async {
    emit(const PostsState.loading());

    final result = await _getPost(
      GetPostParams(id: event.id, forceRefresh: event.forceRefresh),
    );

    result.fold(
      (failure) => emit(PostsState.error(failure)),
      (post) => emit(PostsState.loaded(post: post)),
    );
  }

  Future<void> _onLoadPosts(
    _EventLoadPosts event,
    Emitter<PostsState> emit,
  ) async {
    emit(const PostsState.loading());

    final result = await _getPosts(GetPostsParams(limit: event.limit));

    result.fold(
      (failure) => emit(PostsState.error(failure)),
      (posts) => emit(PostsState.loaded(posts: posts)),
    );
  }
}
