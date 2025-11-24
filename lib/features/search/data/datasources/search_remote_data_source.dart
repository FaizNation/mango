import 'package:mango/features/home/data/models/comic_model.dart';

abstract class SearchRemoteDataSource {
  Future<List<ComicModel>> searchComics(String query, {int page = 1});
}
