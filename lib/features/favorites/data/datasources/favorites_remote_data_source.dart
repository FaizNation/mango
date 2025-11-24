import 'package:mango/features/favorites/data/models/favorite_comic_model.dart';
import 'package:mango/features/home/domain/entities/comic_entity.dart';

abstract class FavoritesRemoteDataSource {
  Stream<List<FavoriteComicModel>> getFavorites();

  Future<void> addFavorite(ComicEntity comic);

  Future<void> removeFavorite(String comicId);
}
