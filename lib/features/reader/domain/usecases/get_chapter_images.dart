import 'package:dartz/dartz.dart';
import 'package:mango/core/error/failures.dart';
import 'package:mango/features/reader/domain/repositories/reader_repository.dart';

class GetChapterImages {
  final ReaderRepository repository;

  GetChapterImages(this.repository);

  Future<Either<Failure, List<String>>> call(String chapterId) async {
    return await repository.getChapterImages(chapterId);
  }
}
