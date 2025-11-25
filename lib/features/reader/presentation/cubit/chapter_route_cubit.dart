import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mango/core/domain/entities/chapter.dart';
import 'package:mango/features/reader/domain/usecases/get_chapters.dart';

part 'chapter_route_state.dart';

class ChapterRouteCubit extends Cubit<ChapterRouteState> {
  final GetChapters _getChapters;

  ChapterRouteCubit({required GetChapters getChapters})
      : _getChapters = getChapters,
        super(ChapterRouteLoading());

  Future<void> loadChapterData(String comicId, String chapterId) async {
    final result = await _getChapters(comicId);

    result.fold(
      (failure) {
        emit(ChapterRouteError('Failed to load chapters: ${failure.message}'));
      },
      (chapters) {
        try {
          final chapter = chapters.firstWhere((c) => c.id == chapterId);
          emit(ChapterRouteSuccess(chapter: chapter, allChapters: chapters));
        } catch (e) {
          // Handle case where chapterId is not found in the list
          emit(const ChapterRouteError('Chapter not found'));
        }
      },
    );
  }
}
