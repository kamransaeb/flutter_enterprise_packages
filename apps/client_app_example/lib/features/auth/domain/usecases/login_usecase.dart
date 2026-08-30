import 'dart:async';

import 'package:client_app_example/features/auth/domain/entities/auth_user.dart';
import 'package:client_app_example/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:enterprise_core/enterprise_core.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

/// Use case for logging in a user.
@injectable
class LoginUseCase implements BaseUseCase<AuthUser, LoginParams> {
  /// Creates a new [LoginUseCase] instance.
  LoginUseCase(this._authRepository);

  /// The repository for the authentication service.
  final AuthRepository _authRepository;

  @override
  FutureOr<Either<Failure, AuthUser>> call(LoginParams params) {
    return _authRepository.login(
      email: params.email,
      password: params.password,
    );
  }
  
}

/// Parameters for the login use case.
class LoginParams extends Equatable {
  /// Creates a new [LoginParams] instance.
  const LoginParams({
    required this.email,
    required this.password,
  });

  /// The email of the user.
  final String email;

  /// The password of the user.
  final String password;

  @override
  List<Object> get props => [email, password];
}
