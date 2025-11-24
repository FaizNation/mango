import 'package:mango/core/error/exceptions.dart';
import 'package:mango/core/network/api_client.dart';
import 'package:mango/core/utils/json_parser.dart';
import 'package:mango/features/reader/data/datasources/reader_remote_data_source.dart';
import 'package:mango/features/reader/data/models/chapter_model.dart';

class ReaderRemoteDataSourceImpl implements ReaderRemoteDataSource {
  final ApiClient apiClient;

  ReaderRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<ChapterModel>> getChapters(String comicId) async {
    try {
      // Prefer fetching the comic detail which often contains nested chapters
      final detailResp = await apiClient.dio.get('/api/comics/$comicId');
      final map = JsonParser.extractMap(detailResp.data);
      var chaptersRaw =
          map['chapters'] ??
          map['data']?['chapters'] ??
          map['results']?['chapters'];
      var chaptersList = JsonParser.extractList(chaptersRaw);
      
      if (chaptersList.isNotEmpty) {
        var parsed = chaptersList
            .map((e) => ChapterModel.fromApi(e as Map<String, dynamic>, comicId))
            .toList();
        _sortChapters(parsed);
        return parsed;
      }

      // Fallback: try direct chapters endpoint
      final resp = await apiClient.dio.get('/api/chapters/$comicId');
      final data = JsonParser.extractList(resp.data);
      var parsed = data
          .map((e) => ChapterModel.fromApi(e as Map<String, dynamic>, comicId))
          .toList();
      _sortChapters(parsed);
      return parsed;
    } catch (e) {
      throw ServerException('Failed to load chapters: $e');
    }
  }

  @override
  Future<List<String>> getChapterImages(String chapterId) async {
    try {
      // Try direct chapter detail first (often has images embedded)
      final resp = await apiClient.dio.get('/api/chapters/$chapterId');
      final map = JsonParser.extractMap(resp.data);

      // Look for images array in various locations/formats
      var rawImages =
          map['images'] ??
          map['data']?['images'] ??
          map['pages'] ??
          map['data']?['pages'] ??
          map['content'] ??
          map['data']?['content'];

      var imagesList = JsonParser.extractList(rawImages);

      if (imagesList.isEmpty) {
        // Fallback: try dedicated images endpoint
        final imagesResp = await apiClient.dio.get('/api/chapters/$chapterId/images');
        final imagesData = JsonParser.extractList(imagesResp.data);
        if (imagesData.isNotEmpty) {
          imagesList = imagesData;
        }
      }

      // Process each image entry which could be string or object
      return imagesList
          .map((img) {
            String? url;
            if (img is String) {
              url = img;
            } else if (img is Map) {
              // Try all possible image URL field names
              url =
                  img['url'] ??
                  img['src'] ??
                  img['path'] ??
                  img['file'] ??
                  img['image'] ??
                  img['link'] ??
                  img['href'] ??
                  img['source'] ??
                  img['imageUrl'] ??
                  img['image_url'] ??
                  img['url_image'] ??
                  img['img_url'] ??
                  img['download_url'] ??
                  img.toString();
            } else {
              url = img.toString();
            }

            // Validate URL
            if (url != null &&
                url.isNotEmpty &&
                (url.startsWith('http://') || url.startsWith('https://'))) {
              return url;
            }
            return '';
          })
          .where((url) => url.isNotEmpty)
          .toList();
    } catch (e) {
      throw ServerException('Failed to load chapter images: $e');
    }
  }

  void _sortChapters(List<ChapterModel> chapters) {
    chapters.sort((a, b) {
      final an = a.chapterNumber;
      final bn = b.chapterNumber;
      if (an != null && bn != null) return an.compareTo(bn);
      if (an != null) return -1; // put known numbers first
      if (bn != null) return 1;
      // fallback: try to extract number from title
      final aNum = _extractFirstInt(a.title);
      final bNum = _extractFirstInt(b.title);
      if (aNum != null && bNum != null) return aNum.compareTo(bNum);
      if (aNum != null) return -1;
      if (bNum != null) return 1;
      return 0;
    });
  }

  int? _extractFirstInt(String? input) {
    if (input == null || input.isEmpty) return null;
    final reg = RegExp(r"(\d+)");
    final match = reg.firstMatch(input);
    if (match != null) return int.tryParse(match.group(0)!);
    return null;
  }
}
