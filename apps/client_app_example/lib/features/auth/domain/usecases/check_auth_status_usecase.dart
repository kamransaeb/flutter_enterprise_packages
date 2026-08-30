import 'dart:async';

import 'package:client_app_example/features/auth/domain/entities/auth_user.dart';
import 'package:client_app_example/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:enterprise_core/enterprise_core.dart';
import 'package:injectable/injectable.dart';

/// Checks whether a valid session exists and loads the current user when it does.
///
/// Returns:
/// - `Right(null)` — not authenticated
/// - `Right(user)` — authenticated
/// - `Left(failure)` — error while loading the user
@injectable
class CheckAuthStatusUseCase extends BaseUseCase<AuthUser?, NoParams> {
  /// Creates a new [CheckAuthStatusUseCase] instance.
  CheckAuthStatusUseCase(this._repository);

  final AuthRepository _repository;

  @override
  FutureOr<Either<Failure, AuthUser?>> call(NoParams params) async {
    final isAuthenticated = await _repository.isAuthenticated();
    if (!isAuthenticated) {
      return const Right(null);
    }

    return _repository.getCurrentUser();
  }
}
