import 'package:mango/core/error/exceptions.dart';
import 'package:mango/core/network/api_client.dart'; 
import 'package:mango/core/utils/json_parser.dart'; 
import 'package:mango/features/home/data/datasources/home_remote_data_source.dart';
import 'package:mango/features/home/data/models/comic_model.dart';

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final ApiClient apiClient;

  HomeRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<ComicModel>> getComics({int page = 1}) async {
    try {
      final resp = await apiClient.dio.get(
        '/api/comics',
        queryParameters: {'page': page},
      );

      final list = JsonParser.extractList(resp.data);
      
      return list
          .map((e) => ComicModel.fromApi(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException('Failed to load comics: $e');
    }
  }

  @override
  Future<List<ComicModel>> getComicsByType(String type, {int page = 1}) async {
    try {
      final resp = await apiClient.dio.get(
        '/api/comics/type/$type',
        queryParameters: {'page': page},
      );
      
      final list = JsonParser.extractList(resp.data);
      
      return list
          .map((e) => ComicModel.fromApi(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException('Failed to load comics by type: $e');
    }
  }
}