import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mango/features/comic_detail/domain/usecases/get_comic_detail.dart';
import 'comic_detail_state.dart';

class ComicDetailRouteCubit extends Cubit<ComicDetailRouteState> {
  final GetComicDetail _getComicDetail;

  ComicDetailRouteCubit({required GetComicDetail getComicDetail})
      : _getComicDetail = getComicDetail,
        super(ComicDetailRouteLoading());

  Future<void> loadComic(String comicId) async {
    try {
      final comic = await _getComicDetail(comicId);
      emit(ComicDetailRouteSuccess(comic));
    } catch (e) {
      emit(ComicDetailRouteError('Failed to load comic: $e'));
    }
  }
}

