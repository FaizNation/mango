import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mango/core/network/api_client.dart';
import 'package:mango/core/utils/json_parser.dart';
import 'package:mango/core/domain/entities/chapter.dart';
import 'comic_detail_state.dart';

class ComicDetailCubit extends Cubit<ComicDetailState> {
  final ApiClient _apiClient;

  ComicDetailCubit(this._apiClient) : super(ComicDetailInitial());

  Future<void> fetchChapters(int comicId) async {
    emit(ComicDetailLoading());
    try {
      // Fetch chapters from API
      final resp = await _apiClient.dio.get('/api/comics/$comicId');
      final map = JsonParser.extractMap(resp.data);
      var chaptersRaw =
          map['chapters'] ??
          map['data']?['chapters'] ??
          map['results']?['chapters'];
      var chaptersList = JsonParser.extractList(chaptersRaw);
      
      List<Chapter> chapters = [];
      if (chaptersList.isNotEmpty) {
        chapters = chaptersList
            .map((e) => Chapter.fromApi(e as Map<String, dynamic>, comicId.toString()))
            .toList();
      } else {
        final chaptersResp = await _apiClient.dio.get('/api/chapters/$comicId');
        final data = JsonParser.extractList(chaptersResp.data);
        chapters = data
            .map((e) => Chapter.fromApi(e as Map<String, dynamic>, comicId.toString()))
            .toList();
      }

      emit(ComicDetailLoaded(chapters));
    } catch (e) {
      emit(ComicDetailError('Failed to load chapters: $e'));
    }
  }
}
