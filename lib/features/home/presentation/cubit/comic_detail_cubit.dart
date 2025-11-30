import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mango/core/network/api_client.dart';
import 'package:mango/core/utils/json_parser.dart';
import 'package:mango/core/domain/entities/chapter.dart';
import 'comic_detail_state.dart';

class ComicDetailCubit extends Cubit<ComicDetailState> {
  final ApiClient _apiClient;
  
  List<Chapter> _allChapters = [];
  static const int _chaptersPerPage = 20;
  int _currentPage = 0;

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

      // Sort chapters by chapter number descending (newest first)
      chapters.sort((a, b) {
        // Extract chapter number from title or id
        final aNum = _extractChapterNumber(a);
        final bNum = _extractChapterNumber(b);
        return bNum.compareTo(aNum); // Descending order
      });

      // Store all chapters
      _allChapters = chapters;
      _currentPage = 0;

      // Emit first batch
      final firstBatch = _allChapters.take(_chaptersPerPage).toList();
      final hasMore = _allChapters.length > _chaptersPerPage;
      
      emit(ComicDetailLoaded(firstBatch, hasMore: hasMore));
    } catch (e) {
      emit(ComicDetailError('Failed to load chapters: $e'));
    }
  }

  void loadMoreChapters() {
    final currentState = state;
    if (currentState is! ComicDetailLoaded || currentState.isLoadingMore || !currentState.hasMore) {
      return;
    }

    // Set loading state
    emit(currentState.copyWith(isLoadingMore: true));

    // Calculate next batch
    _currentPage++;
    final startIndex = _currentPage * _chaptersPerPage;
    final endIndex = startIndex + _chaptersPerPage;
    
    final nextBatch = _allChapters.skip(startIndex).take(_chaptersPerPage).toList();
    final allLoadedChapters = [...currentState.chapters, ...nextBatch];
    final hasMore = endIndex < _allChapters.length;

    // Emit updated state
    emit(ComicDetailLoaded(
      allLoadedChapters,
      hasMore: hasMore,
      isLoadingMore: false,
    ));
  }

  double _extractChapterNumber(Chapter chapter) {
    // Try to extract number from title like "Chapter 123" or "Ch. 123"
    final titleMatch = RegExp(r'(\d+\.?\d*)').firstMatch(chapter.title);
    if (titleMatch != null) {
      return double.tryParse(titleMatch.group(1)!) ?? 0;
    }
    
    // Fallback to ID if available
    final idMatch = RegExp(r'(\d+\.?\d*)').firstMatch(chapter.id);
    if (idMatch != null) {
      return double.tryParse(idMatch.group(1)!) ?? 0;
    }
    
    return 0;
  }
}
