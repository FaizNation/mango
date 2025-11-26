import 'package:mango/core/domain/entities/comic/comic.dart';
import 'package:mango/features/comic_detail/domain/repositories/comic_detail_repository.dart';
import 'package:mango/features/comic_detail/data/datasources/comic_detail_remote_data_source.dart';

class ComicDetailRepositoryImpl implements ComicDetailRepository {
  final ComicDetailRemoteDataSource remoteDataSource;

  ComicDetailRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Comic> getComicDetail(String comicId) async {
    return await remoteDataSource.fetchComicDetail(comicId);
  }
}
