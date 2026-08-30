import 'package:client_app_example/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:enterprise_core/enterprise_core.dart';
import 'package:injectable/injectable.dart';

/// Injectable bindings for the logout use case.
/// [LogoutUseCase] is used to logout a user from the application.
@injectable
class LogoutUseCase extends BaseUseCase<void, NoParams> {
  /// Creates a new [LogoutUseCase] instance.
  LogoutUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, void>> call(NoParams params) => _repository.logout();
}
