import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/api_service.dart' as service;
import '../../models/chapter.dart';
import 'chapter_state.dart';

class ChapterRouteCubit extends Cubit<ChapterRouteState> {
  final service.ApiService _api;

  ChapterRouteCubit(this._api) : super(ChapterRouteLoading());

  // Ini adalah fungsi _load yang sudah dipindah
  Future<void> loadChapterData(String comicId, String chapterId) async {
    // Tidak perlu emit Loading() di sini, karena sudah di state awal
    try {
      // 1. Ambil semua chapter
      final List<Chapter> chapters = await _api.getChapters(comicId);
      Chapter? chapter;

      // 2. Cari chapter yang spesifik
      try {
        chapter = chapters.firstWhere((c) => c.id == chapterId);
      } catch (_) {
        // 3. Fallback: Jika tidak ketemu, ambil chapter pertama
        if (chapters.isNotEmpty) {
          chapter = chapters[0];
        } else {
          chapter = null;
        }
      }

      // 4. Periksa hasil dan emit state yang sesuai
      if (chapter != null) {
        emit(ChapterRouteSuccess(chapter: chapter, allChapters: chapters));
      } else {
        emit(const ChapterRouteError('Chapter not found'));
      }
    } catch (e) {
      emit(ChapterRouteError('Failed to load chapters: $e'));
    }
  }
}