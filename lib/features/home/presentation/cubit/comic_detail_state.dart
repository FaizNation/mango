import 'package:mango/core/domain/entities/chapter.dart';

abstract class ComicDetailState {}

class ComicDetailInitial extends ComicDetailState {}

class ComicDetailLoading extends ComicDetailState {}

class ComicDetailLoaded extends ComicDetailState {
  final List<Chapter> chapters;

  ComicDetailLoaded(this.chapters);
}

class ComicDetailError extends ComicDetailState {
  final String message;

  ComicDetailError(this.message);
}
