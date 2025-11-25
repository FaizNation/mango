import 'package:equatable/equatable.dart';
// Note: Failure import removed because this file only defines UseCase abstractions.

// Using Either from a package like dartz or fpdart is common,
// but for simplicity, we'll use Futures and throw Failures.
abstract class UseCase<Type, Params> {
  Future<Type> call(Params params);
}

// A special class for use cases that don't take any parameters.
class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}

abstract class StreamUseCase<Type, Params> {
  Stream<Type> call(Params params);
}
