import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mango/core/domain/entities/chapter.dart';
import 'package:mango/features/reader/domain/usecases/get_chapter_images.dart';
import 'package:mango/core/utils/image_proxy.dart';

part 'chapter_state.dart';

class ChapterCubit extends Cubit<ChapterState> {
  final GetChapterImages getChapterImages;

  ChapterCubit({
    required Chapter initialChapter,
    required List<Chapter> allChapters,
    required this.getChapterImages,
  }) : super(
          ChapterState(
            currentChapter: initialChapter,
            allChapters: List<Chapter>.from(allChapters),
            isLoading: false,
            error: null,
          ),
        );

  Future<void> ensureImagesForChapter(Chapter chapter) async {
    if (chapter.images.isNotEmpty) return;
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final result = await getChapterImages(chapter.id);
      
      result.fold(
        (failure) {
          emit(
            state.copyWith(isLoading: false, error: 'Failed to load images: ${failure.message}'),
          );
        },
        (imgs) {
          // use ImageProxy to wrap URLs to avoid CORS on web
          final proxied = ImageProxy.proxyList(imgs);
          final updated = Chapter(
            id: chapter.id,
            title: chapter.title,
            comicId: chapter.comicId,
            images: proxied,
            chapterNumber: chapter.chapterNumber,
            publishedAt: chapter.publishedAt,
          );

          // update allChapters list and currentChapter if matching
          final newList = List<Chapter>.from(state.allChapters);
          final idx = newList.indexWhere((c) => c.id == chapter.id);
          if (idx != -1) newList[idx] = updated;

          emit(
            state.copyWith(
              isLoading: false,
              currentChapter: updated,
              allChapters: newList,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        state.copyWith(isLoading: false, error: 'Failed to load images: $e'),
      );
    }
  }

  void navigateToChapter(Chapter chapter) {
    emit(state.copyWith(currentChapter: chapter, error: null));
    // ensure images will be loaded (async)
    ensureImagesForChapter(chapter);
  }
}
