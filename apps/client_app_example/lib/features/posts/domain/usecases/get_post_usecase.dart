import 'package:client_app_example/features/posts/domain/entities/post.dart';
import 'package:client_app_example/features/posts/domain/repositories/posts_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:enterprise_core/enterprise_core.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

/// Fetches a single post by id.
@injectable
class GetPostUseCase extends BaseUseCase<Post, GetPostParams> {
  /// Creates a [GetPostUseCase].
  GetPostUseCase(this._postsRepository);

  final PostsRepository _postsRepository;

  @override
  Future<Either<Failure, Post>> call(GetPostParams params) async {
    return _postsRepository.getPost(
      params.id,
      forceRefresh: params.forceRefresh,
    );
  }
}

/// Params for [GetPostUseCase].
class GetPostParams extends Equatable {
  /// Creates a [GetPostParams].
  const GetPostParams({required this.id, this.forceRefresh = false});

  /// The id of the post to fetch.
  final int id;

  /// Whether to force refresh the post.
  final bool forceRefresh;

  @override
  List<Object> get props => [id, forceRefresh];
}
