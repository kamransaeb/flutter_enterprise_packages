import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_enterprise_boilerplate/core/errors/failures.dart';

abstract class BaseUseCase<Type, Params> {
  FutureOr<Either<Failure, Type>> call(Params params);
}

class NoParams extends Equatable {
  const NoParams();
  
  @override
  List<Object> get props => [];
}