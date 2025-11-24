import 'package:dartz/dartz.dart';
import 'package:mango/core/error/exceptions.dart';
import 'package:mango/core/error/failures.dart';
import 'package:mango/core/domain/entities/chapter.dart';
import 'package:mango/features/reader/data/datasources/reader_remote_data_source.dart';
import 'package:mango/features/reader/domain/repositories/reader_repository.dart';

class ReaderRepositoryImpl implements ReaderRepository {
  final ReaderRemoteDataSource remoteDataSource;

  ReaderRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Chapter>>> getChapters(String comicId) async {
    try {
      final result = await remoteDataSource.getChapters(comicId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getChapterImages(String chapterId) async {
    try {
      final result = await remoteDataSource.getChapterImages(chapterId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
