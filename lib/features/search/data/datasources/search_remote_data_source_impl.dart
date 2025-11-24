import 'package:mango/core/error/exceptions.dart';
import 'package:mango/core/network/api_client.dart';
import 'package:mango/core/utils/json_parser.dart';
import 'package:mango/features/home/data/models/comic_model.dart';
import 'package:mango/features/search/data/datasources/search_remote_data_source.dart';

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final ApiClient apiClient;

  SearchRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<ComicModel>> searchComics(String query, {int page = 1}) async {
    try {
      final resp = await apiClient.dio.get(
        '/api/search',
        queryParameters: {'q': query, 'page': page},
      );
      final data = JsonParser.extractList(resp.data);
      return data.map((e) => ComicModel.fromApi(e as Map<String, dynamic>)).toList();
    } catch (e) {
      throw ServerException('Failed to search comics: $e');
    }
  }
}
