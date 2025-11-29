import 'package:mango/core/error/exceptions.dart';
import 'package:mango/core/error/failure.dart';
import 'package:mango/features/favorites/data/datasources/favorites_remote_data_source.dart';
import 'package:mango/features/home/domain/entities/comic_entity.dart';
import 'package:mango/features/favorites/domain/repositories/favorites_repository.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesRemoteDataSource remoteDataSource;

  FavoritesRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<List<ComicEntity>> getFavorites() {
    try {
      return remoteDataSource.getFavorites();
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<void> addFavorite(ComicEntity comic) async {
    try {
      await remoteDataSource.addFavorite(comic);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<void> removeFavorite(String comicId) async {
    try {
      await remoteDataSource.removeFavorite(comicId);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }
}
