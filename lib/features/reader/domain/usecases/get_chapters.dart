import 'package:dartz/dartz.dart';
import 'package:mango/core/error/failures.dart';
import 'package:mango/core/domain/entities/chapter.dart';
import 'package:mango/features/reader/domain/repositories/reader_repository.dart';

class GetChapters {
  final ReaderRepository repository;

  GetChapters(this.repository);

  Future<Either<Failure, List<Chapter>>> call(String comicId) async {
    return await repository.getChapters(comicId);
  }
}
