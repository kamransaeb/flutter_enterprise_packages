import 'package:dartz/dartz.dart';

extension EitherX<L, R> on Either<L, R> {
  R? get rightOrNull => fold((_) => null, (r) => r);
  L? get leftOrNull => fold((l) => l, (_) => null);

  R getOrElse(R defaultValue) => fold((_) => defaultValue, (r) => r);
  L leftOrElse(L defaultValue) => fold((l) => l, (_) => defaultValue);
}

extension FutureEitherX<L, R> on Future<Either<L, R>> {
  Future<R?> get rightOrNull async => (await this).rightOrNull;
  Future<L?> get leftOrNull async => (await this).leftOrNull;

  Future<R> getOrElse(R defaultValue) async =>
      (await this).fold((_) => defaultValue, (r) => r);
}

extension EitherExceptionX<L extends Exception, R> on Either<L, R> {
  R? get valueOrNull => fold((_) => null, (r) => r);
  L? get exceptionOrNull => fold((l) => l, (_) => null);
}