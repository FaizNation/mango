import 'package:mango/features/home/data/models/comic_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<ComicModel>> getComics({int page = 1});
  Future<List<ComicModel>> getComicsByType(String type, {int page = 1});
}
