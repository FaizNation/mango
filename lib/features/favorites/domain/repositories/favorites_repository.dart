import 'package:mango/core/error/failure.dart';
import 'package:mango/features/home/domain/entities/comic_entity.dart';

abstract class FavoritesRepository {
  /// Throws a [ServerFailure] if a server error occurs or if the user is not logged in.
  Stream<List<ComicEntity>> getFavorites();

  /// Throws a [ServerFailure] if a server error occurs or if the user is not logged in.
  Future<void> addFavorite(ComicEntity comic);

  /// Throws a [ServerFailure] if a server error occurs or if the user is not logged in.
  Future<void> removeFavorite(String comicId);
}
