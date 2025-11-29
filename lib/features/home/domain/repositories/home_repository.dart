import 'package:mango/core/error/failure.dart';
import 'package:mango/features/home/domain/entities/comic_entity.dart';

abstract class HomeRepository {
  /// Throws a [ServerFailure] if a server error occurs.
  Future<List<ComicEntity>> getComics({int page = 1});

  /// Throws a [ServerFailure] if a server error occurs.
  Future<List<ComicEntity>> getComicsByType(String type, {int page = 1});
}
