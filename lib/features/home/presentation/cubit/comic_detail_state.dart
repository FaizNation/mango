import 'package:mango/core/domain/entities/chapter.dart';

abstract class ComicDetailState {}

class ComicDetailInitial extends ComicDetailState {}

class ComicDetailLoading extends ComicDetailState {}

class ComicDetailLoaded extends ComicDetailState {
  final List<Chapter> chapters;
  final bool hasMore;
  final bool isLoadingMore;

  ComicDetailLoaded(
    this.chapters, {
    this.hasMore = false,
    this.isLoadingMore = false,
  });

  ComicDetailLoaded copyWith({
    List<Chapter>? chapters,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return ComicDetailLoaded(
      chapters ?? this.chapters,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class ComicDetailError extends ComicDetailState {
  final String message;

  ComicDetailError(this.message);
}
