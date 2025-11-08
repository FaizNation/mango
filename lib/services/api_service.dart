import 'package:dio/dio.dart';
import '../models/comic/comic.dart';
import '../models/chapter.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'APA MASS?',
      connectTimeout: const Duration(seconds: 8),
      receiveTimeout: const Duration(seconds: 8),
    ),
  );

  // GET /api/comics
  Future<List<Comic>> getComics({int page = 1}) async {
    try {
      final resp = await _dio.get(
        '/api/comics',
        queryParameters: {'page': page},
      );
      final data = _extractList(resp.data);
      return data.map((e) => Comic.fromApi(e as Map<String, dynamic>)).toList();
    } catch (e) {
      throw Exception('Failed to load comics: $e');
    }
  }

  // GET /api/comics/type/:type  (type: manga, manhwa, manhua)
  Future<List<Comic>> getComicsByType(String type, {int page = 1}) async {
    try {
      final resp = await _dio.get(
        '/api/comics/type/$type',
        queryParameters: {'page': page},
      );
      final data = _extractList(resp.data);
      return data.map((e) => Comic.fromApi(e as Map<String, dynamic>)).toList();
    } catch (e) {
      throw Exception('Failed to load comics by type: $e');
    }
  }

  // GET /api/comics/:id
  Future<Comic> getComicDetail(String id) async {
    try {
      final resp = await _dio.get('/api/comics/$id');
      final map = _extractMap(resp.data);
      return Comic.fromApi(map);
    } catch (e) {
      throw Exception('Failed to load comic detail: $e');
    }
  }

  // GET /api/search?q=...
  Future<List<Comic>> searchComics(String q, {int page = 1}) async {
    try {
      final resp = await _dio.get(
        '/api/search',
        queryParameters: {'q': q, 'page': page},
      );
      final data = _extractList(resp.data);
      return data.map((e) => Comic.fromApi(e as Map<String, dynamic>)).toList();
    } catch (e) {
      throw Exception('Failed to search comics: $e');
    }
  }

  // GET /api/chapters/:id  -> list of chapters for comic id
  Future<List<Chapter>> getChapters(String comicId) async {
    try {
      // Prefer fetching the comic detail which often contains nested chapters
      final detailResp = await _dio.get('/api/comics/$comicId');
      final map = _extractMap(detailResp.data);
      var chaptersRaw =
          map['chapters'] ??
          map['data']?['chapters'] ??
          map['results']?['chapters'];
      var chaptersList = _extractList(chaptersRaw);
      if (chaptersList.isNotEmpty) {
        var parsed = chaptersList
            .map((e) => Chapter.fromApi(e as Map<String, dynamic>, comicId))
            .toList();
        // sort numerically by chapterNumber if possible, ascending
        parsed.sort((a, b) {
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
        return parsed;
      }

      // Fallback: try direct chapters endpoint
      final resp = await _dio.get('/api/chapters/$comicId');
      final data = _extractList(resp.data);
      var parsed = data
          .map((e) => Chapter.fromApi(e as Map<String, dynamic>, comicId))
          .toList();
      parsed.sort((a, b) {
        final an = a.chapterNumber;
        final bn = b.chapterNumber;
        if (an != null && bn != null) return an.compareTo(bn);
        if (an != null) return -1;
        if (bn != null) return 1;
        final aNum = _extractFirstInt(a.title);
        final bNum = _extractFirstInt(b.title);
        if (aNum != null && bNum != null) return aNum.compareTo(bNum);
        if (aNum != null) return -1;
        if (bNum != null) return 1;
        return 0;
      });
      return parsed;
    } catch (e) {
      throw Exception('Failed to load chapters: $e');
    }
  }

  // GET /api/chapters/:id/images -> images for chapter id
  Future<List<String>> getChapterImages(String chapterId) async {
    try {
      // Try direct chapter detail first (often has images embedded)
      final resp = await _dio.get('/api/chapters/$chapterId');
      final map = _extractMap(resp.data);

      // Look for images array in various locations/formats
      var rawImages =
          map['images'] ??
          map['data']?['images'] ??
          map['pages'] ??
          map['data']?['pages'] ??
          map['content'] ??
          map['data']?['content'];

      var imagesList = _extractList(rawImages);

      if (imagesList.isEmpty) {
        // Fallback: try dedicated images endpoint
        final imagesResp = await _dio.get('/api/chapters/$chapterId/images');
        final imagesData = _extractList(imagesResp.data);
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
      throw Exception('Failed to load chapter images: $e');
    }
  }

  // Helpers to handle variable shapes
  List _extractList(dynamic data) {
    if (data == null) return [];
    if (data is List) return data;
    if (data is Map) {
      if (data['data'] is List) return data['data'];
      if (data['results'] is List) return data['results'];
      if (data['comics'] is List) return data['comics'];
      if (data['chapters'] is List) return data['chapters'];
      if (data['items'] is List) return data['items'];
      // maybe top-level object with array under 'items'
      // if single object representing one item, wrap it
      return [data];
    }
    return [];
  }

  Map<String, dynamic> _extractMap(dynamic data) {
    if (data == null) return {};
    if (data is Map<String, dynamic>) {
      if (data['data'] is Map<String, dynamic>) {
        return Map<String, dynamic>.from(data['data']);
      }
      if (data['result'] is Map<String, dynamic>) {
        return Map<String, dynamic>.from(data['result']);
      }
      // assume top-level is the object
      return Map<String, dynamic>.from(data);
    }
    return {};
  }

  // Attempt to extract the first integer found in a string (e.g. "Chapter 12" -> 12)
  int? _extractFirstInt(String? input) {
    if (input == null || input.isEmpty) return null;
    final reg = RegExp(r"(\d+)");
    final match = reg.firstMatch(input);
    if (match != null) return int.tryParse(match.group(0)!);
    return null;
  }
}
