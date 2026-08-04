import 'package:dartz/dartz.dart';

/// Helpers for reading values from [Either] without exhaustive folding.
extension EitherX<L, R> on Either<L, R> {
  /// The right value, or `null` when this is a [Left].
  R? get rightOrNull => fold((_) => null, (r) => r);

  /// The left value, or `null` when this is a [Right].
  L? get leftOrNull => fold((l) => l, (_) => null);

  /// Returns the right value, or [defaultValue] when this is a [Left].
  R getOrElseValue(R defaultValue) =>
      fold((_) => defaultValue, (r) => r);

  /// Returns the left value, or [defaultValue] when this is a [Right].
  L leftOrElse(L defaultValue) => fold((l) => l, (_) => defaultValue);
}

/// Async helpers for [Future]s that resolve to [Either].
extension FutureEitherX<L, R> on Future<Either<L, R>> {
  /// The right value, or `null` when the result is a [Left].
  Future<R?> get rightOrNull async => (await this).rightOrNull;

  /// The left value, or `null` when the result is a [Right].
  Future<L?> get leftOrNull async => (await this).leftOrNull;

  /// Returns the right value, or [defaultValue] when the result is a [Left].
  Future<R> getOrElseValue(R defaultValue) async =>
      (await this).fold((_) => defaultValue, (r) => r);
}

/// Helpers when the left side is an [Exception].
extension EitherExceptionX<L extends Exception, R> on Either<L, R> {
  /// The right value, or `null` when this is a [Left].
  R? get valueOrNull => fold((_) => null, (r) => r);

  /// The left [Exception], or `null` when this is a [Right].
  L? get exceptionOrNull => fold((l) => l, (_) => null);
}
