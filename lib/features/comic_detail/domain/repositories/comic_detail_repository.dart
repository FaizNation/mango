import 'package:mango/core/domain/entities/comic/comic.dart';

abstract class ComicDetailRepository {
  Future<Comic> getComicDetail(String comicId);
}
