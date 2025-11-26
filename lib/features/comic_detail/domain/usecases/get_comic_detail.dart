import 'package:mango/core/domain/entities/comic/comic.dart';
import 'package:mango/core/usecase/usecase.dart';
import 'package:mango/features/comic_detail/domain/repositories/comic_detail_repository.dart';

class GetComicDetail extends UseCase<Comic, String> {
  final ComicDetailRepository repository;

  GetComicDetail(this.repository);

  @override
  Future<Comic> call(String params) async {
    return await repository.getComicDetail(params);
  }
}
