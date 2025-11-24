import 'package:dartz/dartz.dart';
import 'package:mango/core/error/failures.dart';
import 'package:mango/features/home/domain/entities/comic_entity.dart';

abstract class SearchRepository {
  Future<Either<Failure, List<ComicEntity>>> searchComics(String query, {int page = 1});
}
