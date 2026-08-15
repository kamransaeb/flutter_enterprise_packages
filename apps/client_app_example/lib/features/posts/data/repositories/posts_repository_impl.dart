import 'package:client_app_example/features/posts/data/datasources/posts_remote_data_source.dart';
import 'package:client_app_example/features/posts/domain/entities/post.dart';
import 'package:client_app_example/features/posts/domain/repositories/posts_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:enterprise_core/enterprise_core.dart';
import 'package:injectable/injectable.dart';

/// Implementation of the PostsRepository interface
@LazySingleton(as: PostsRepository)
class PostsRepositoryImpl implements PostsRepository {
  /// Constructor.
  PostsRepositoryImpl(this._postsRemoteDataSource, this._errorHandler);

  final PostsRemoteDataSource _postsRemoteDataSource;
  final ErrorHandler _errorHandler;

  /// Get a post by ID.
  @override
  Future<Either<Failure, Post>> getPost(
    int id, {
    bool forceRefresh = false,
  }) async {
    try {
      final response = await _postsRemoteDataSource.getPost(
        id,
        forceRefresh: forceRefresh,
      );
      return Right(response.toEntity());
    } on Object catch (e, stackTrace) {
      return Left(
        _errorHandler.handleError(
          e,
          stackTrace: stackTrace,
          reason: 'getPost',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<Post>>> getPosts({int limit = 5}) async {
    try {
      final response = await _postsRemoteDataSource.getPosts(limit: limit);
      return Right(response.map((e) => e.toEntity()).toList());
    } on Object catch (e, stackTrace) {
      return Left(
        _errorHandler.handleError(
          e,
          stackTrace: stackTrace,
          reason: 'getPosts',
        ),
      );
    }
  }
}
