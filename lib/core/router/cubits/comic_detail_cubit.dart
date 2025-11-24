import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mango/core/domain/entities/comic/comic.dart';
import 'package:mango/core/network/api_client.dart';
import 'package:mango/core/utils/json_parser.dart';
import 'comic_detail_state.dart';

class ComicDetailRouteCubit extends Cubit<ComicDetailRouteState> {
  final ApiClient _api;

  // Mulai dengan state Loading
  ComicDetailRouteCubit(this._api) : super(ComicDetailRouteLoading());

  // Ini adalah fungsi _load yang sudah dipindah
  Future<void> loadComic(String comicId) async {
    try {
      // Use ApiClient directly to fetch comic detail
      final resp = await _api.dio.get('/api/comics/$comicId');
      final map = JsonParser.extractMap(resp.data);
      final Comic comic = Comic.fromApi(map);

      // Emit state Success dengan data comic
      emit(ComicDetailRouteSuccess(comic));
    } catch (e) {
      // Jika API error
      emit(ComicDetailRouteError('Failed to load comic: $e'));
    }
  }
}
