import 'package:mango/features/reader/data/models/chapter_model.dart';

abstract class ReaderRemoteDataSource {
  Future<List<ChapterModel>> getChapters(String comicId);
  Future<List<String>> getChapterImages(String chapterId);
}
