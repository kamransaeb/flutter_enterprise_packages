import 'package:client_app_example/features/posts/domain/entities/post.dart';
import 'package:client_app_example/features/posts/domain/repositories/posts_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:enterprise_core/enterprise_core.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

/// Fetches a list of posts.
@injectable
class GetPostsUseCase extends BaseUseCase<List<Post>, GetPostsParams> {
  
  /// Creates a [GetPostsUseCase].
  GetPostsUseCase(this._postRepository);

  final PostsRepository _postRepository;

  @override
  Future<Either<Failure, List<Post>>> call(GetPostsParams params) async {
    return _postRepository.getPosts(limit: params.limit);
  }
}

/// Input for [GetPostsUseCase].
class GetPostsParams extends Equatable {
  /// Creates [GetPostsParams].
  const GetPostsParams({this.limit = 5});
  /// Max number of posts.
  final int limit;

  @override
  List<Object> get props => [limit];
}
