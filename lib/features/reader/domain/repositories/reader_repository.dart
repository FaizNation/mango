import 'package:dartz/dartz.dart';
import 'package:mango/core/error/failures.dart';
import 'package:mango/core/domain/entities/chapter.dart';

abstract class ReaderRepository {
  Future<Either<Failure, List<Chapter>>> getChapters(String comicId);
  Future<Either<Failure, List<String>>> getChapterImages(String chapterId);
}
