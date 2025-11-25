import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mango/core/network/api_client.dart';
import 'package:mango/core/domain/entities/chapter.dart';
import 'package:mango/core/utils/json_parser.dart';
import 'chapter_state.dart';

class ChapterRouteCubit extends Cubit<ChapterRouteState> {
  final ApiClient _api;

  ChapterRouteCubit(this._api) : super(ChapterRouteLoading());

  Future<void> loadChapterData(String comicId, String chapterId) async {
    try {
      // Use ApiClient directly to fetch chapters
      final resp = await _api.dio.get('/api/comics/$comicId');
      final map = JsonParser.extractMap(resp.data);
      var chaptersRaw =
          map['chapters'] ??
          map['data']?['chapters'] ??
          map['results']?['chapters'];
      var chaptersList = JsonParser.extractList(chaptersRaw);
      
      List<Chapter> chapters = [];
      if (chaptersList.isNotEmpty) {
        chapters = chaptersList
            .map((e) => Chapter.fromApi(e as Map<String, dynamic>, comicId))
            .toList();
      } else {
        // Fallback: try direct chapters endpoint
        final chaptersResp = await _api.dio.get('/api/chapters/$comicId');
        final data = JsonParser.extractList(chaptersResp.data);
        chapters = data
            .map((e) => Chapter.fromApi(e as Map<String, dynamic>, comicId))
            .toList();
      }
      
      Chapter? chapter;
      try {
        chapter = chapters.firstWhere((c) => c.id == chapterId);
      } catch (_) {
        if (chapters.isNotEmpty) {
          chapter = chapters[0];
        } else {
          chapter = null;
        }
      }

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
