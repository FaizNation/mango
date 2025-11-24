import 'package:mango/core/error/failure.dart';
import 'package:mango/features/home/domain/entities/comic_entity.dart';

abstract class FavoritesRepository {
  /// Returns a stream of the user's favorite comics.
  /// Throws a [ServerFailure] if a server error occurs or if the user is not logged in.
  Stream<List<ComicEntity>> getFavorites();

  /// Adds a comic to the user's favorites.
  /// Throws a [ServerFailure] if a server error occurs or if the user is not logged in.
  Future<void> addFavorite(ComicEntity comic);

  /// Removes a comic from the user's favorites by its [comicId].
  /// Throws a [ServerFailure] if a server error occurs or if the user is not logged in.
  Future<void> removeFavorite(String comicId);
}
