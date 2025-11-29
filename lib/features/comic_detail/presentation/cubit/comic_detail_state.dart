import 'package:equatable/equatable.dart';
import 'package:mango/core/domain/entities/comic/comic.dart';

abstract class ComicDetailRouteState extends Equatable {
  const ComicDetailRouteState();

  @override
  List<Object> get props => [];
}

class ComicDetailRouteLoading extends ComicDetailRouteState {}

class ComicDetailRouteError extends ComicDetailRouteState {
  final String message;

  const ComicDetailRouteError(this.message);

  @override
  List<Object> get props => [message];
}

class ComicDetailRouteSuccess extends ComicDetailRouteState {
  final Comic comic;

  const ComicDetailRouteSuccess(this.comic);

  @override
  List<Object> get props => [comic];
}
