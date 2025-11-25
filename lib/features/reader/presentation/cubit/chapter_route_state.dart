part of 'chapter_route_cubit.dart';

abstract class ChapterRouteState extends Equatable {
  const ChapterRouteState();

  @override
  List<Object> get props => [];
}

class ChapterRouteLoading extends ChapterRouteState {}

class ChapterRouteSuccess extends ChapterRouteState {
  final Chapter chapter;
  final List<Chapter> allChapters;

  const ChapterRouteSuccess({required this.chapter, required this.allChapters});

  @override
  List<Object> get props => [chapter, allChapters];
}

class ChapterRouteError extends ChapterRouteState {
  final String message;

  const ChapterRouteError(this.message);

  @override
  List<Object> get props => [message];
}
