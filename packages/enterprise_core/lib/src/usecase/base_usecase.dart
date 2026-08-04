import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:enterprise_core/src/errors/failures.dart';
import 'package:equatable/equatable.dart';

/// Base use case class.
abstract class BaseUseCase<T, Params> {
  /// Calls the use case.
  FutureOr<Either<Failure, T>> call(Params params);
}

/// No params class.
class NoParams extends Equatable {
  /// Creates a new [NoParams] instance.
  const NoParams();
  
  @override
  List<Object> get props => [];
}
