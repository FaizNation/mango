import 'package:dartz/dartz.dart';
import 'package:mango/core/error/failures.dart';
import 'package:mango/features/home/domain/entities/comic_entity.dart';
import 'package:mango/features/search/domain/repositories/search_repository.dart';

class SearchComics {
  final SearchRepository repository;

  SearchComics(this.repository);

  Future<Either<Failure, List<ComicEntity>>> call(String query, {int page = 1}) async {
    return await repository.searchComics(query, page: page);
  }
}
