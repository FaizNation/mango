part of 'reader_screen_cubit.dart';

class ReaderScreenState extends Equatable {
  final Chapter currentChapter;
  final List<Chapter> allChapters;
  final bool isLoading;
  final String? error;

  const ReaderScreenState({
    required this.currentChapter,
    required this.allChapters,
    required this.isLoading,
    this.error,
  });

  ReaderScreenState copyWith({
    Chapter? currentChapter,
    List<Chapter>? allChapters,
    bool? isLoading,
    String? error,
  }) {
    return ReaderScreenState(
      currentChapter: currentChapter ?? this.currentChapter,
      allChapters: allChapters ?? this.allChapters,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [currentChapter, allChapters, isLoading, error];
}
