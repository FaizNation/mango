import 'package:dartz/dartz.dart';
import 'package:mango/core/error/exceptions.dart';
import 'package:mango/core/error/failures.dart';
import 'package:mango/features/home/domain/entities/comic_entity.dart';
import 'package:mango/features/search/data/datasources/search_remote_data_source.dart';
import 'package:mango/features/search/domain/repositories/search_repository.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource remoteDataSource;

  SearchRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ComicEntity>>> searchComics(String query, {int page = 1}) async {
    try {
      final result = await remoteDataSource.searchComics(query, page: page);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
