import 'package:equatable/equatable.dart';
// Note: Failure import removed because this file only defines UseCase abstractions.

// Using Either from a package like dartz or fpdart is common,
// but for simplicity, we'll use Futures and throw Failures.
abstract class UseCase<T, Params> {
  Future<T> call(Params params);
}

// A special class for use cases that don't take any parameters.
class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}

abstract class StreamUseCase<T, Params> {
  Stream<T> call(Params params);
}
