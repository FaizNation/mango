import 'package:mango/core/domain/entities/comic/comic.dart';
import 'package:mango/core/network/api_client.dart';
import 'package:mango/core/utils/json_parser.dart';

abstract class ComicDetailRemoteDataSource {
  Future<Comic> fetchComicDetail(String comicId);
}

class ComicDetailRemoteDataSourceImpl implements ComicDetailRemoteDataSource {
  final ApiClient _apiClient;

  ComicDetailRemoteDataSourceImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<Comic> fetchComicDetail(String comicId) async {
    final resp = await _apiClient.dio.get('/api/comics/$comicId');
    final map = JsonParser.extractMap(resp.data);
    return Comic.fromApi(map);
  }
}
