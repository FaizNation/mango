import 'package:mango/core/error/exceptions.dart';
import 'package:mango/core/error/failure.dart';
import 'package:mango/features/home/data/datasources/home_remote_data_source.dart';
import 'package:mango/features/home/domain/entities/comic_entity.dart';
import 'package:mango/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<ComicEntity>> getComics({int page = 1}) async {
    try {
      // The remote data source returns ComicModels, which are subtypes of ComicEntity.
      // So this direct assignment is valid.
      return await remoteDataSource.getComics(page: page);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<List<ComicEntity>> getComicsByType(String type, {int page = 1}) async {
    try {
      return await remoteDataSource.getComicsByType(type, page: page);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }
}
