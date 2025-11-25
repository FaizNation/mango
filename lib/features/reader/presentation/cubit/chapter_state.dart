part of 'chapter_cubit.dart';

class ChapterState extends Equatable {
  final Chapter currentChapter;
  final List<Chapter> allChapters;
  final bool isLoading;
  final String? error;

  const ChapterState({
    required this.currentChapter,
    required this.allChapters,
    required this.isLoading,
    this.error,
  });

  ChapterState copyWith({
    Chapter? currentChapter,
    List<Chapter>? allChapters,
    bool? isLoading,
    String? error,
  }) {
    return ChapterState(
      currentChapter: currentChapter ?? this.currentChapter,
      allChapters: allChapters ?? this.allChapters,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [currentChapter, allChapters, isLoading, error];
}
