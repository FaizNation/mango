import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/comic/comic.dart';
import '../../services/api_service.dart' as service;
import 'comic_detail_state.dart';

class ComicDetailRouteCubit extends Cubit<ComicDetailRouteState> {
  final service.ApiService _api;

  // Mulai dengan state Loading
  ComicDetailRouteCubit(this._api) : super(ComicDetailRouteLoading());

  // Ini adalah fungsi _load yang sudah dipindah
  Future<void> loadComic(String comicId) async {
    try {
      final Comic? comic = await _api.getComicDetail(comicId);
      
      if (comic != null) {
        // Jika sukses, emit state Success dengan data comic
        emit(ComicDetailRouteSuccess(comic));
      } else {
        // Jika comic-nya null (tidak ketemu)
        emit(const ComicDetailRouteError('Comic not found'));
      }
    } catch (e) {
      // Jika API error
      emit(ComicDetailRouteError('Failed to load comic: $e'));
    }
  }
}