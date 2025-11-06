import 'package:flutter_bloc/flutter_bloc.dart';
import 'comic_detail_state.dart';
import '../../services/api_service.dart' as service;

class ComicDetailCubit extends Cubit<ComicDetailState> {
  final service.ApiService _apiService;

  // Mulai dengan state Initial
  ComicDetailCubit(this._apiService) : super(ComicDetailInitial());

  // Menggantikan fungsi _loadChapters
  Future<void> fetchChapters(int comicId) async {
    // Emit state Loading
    emit(ComicDetailLoading());
    try {
      // Ambil data dari API
      final fetched = await _apiService.getChapters(comicId.toString());
      // Emit state Loaded dengan data chapter
      emit(ComicDetailLoaded(fetched));
    } catch (e) {
      // Emit state Error jika gagal
      emit(ComicDetailError('Failed to load chapters: $e'));
    }
  }
}