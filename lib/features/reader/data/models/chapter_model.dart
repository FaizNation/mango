import 'package:mango/core/domain/entities/chapter.dart';
import 'package:mango/core/utils/image_proxy.dart';

class ChapterModel extends Chapter {
  ChapterModel({
    required super.id,
    required super.title,
    required super.comicId,
    required super.images,
    super.chapterNumber,
    super.publishedAt,
  });

  factory ChapterModel.fromApi(Map<String, dynamic> json, String comicId) {
    return ChapterModel(
      id: _parseId(json),
      title: _parseTitle(json),
      comicId: comicId,
      images: ImageProxy.proxyList(_parseImages(json)),
      chapterNumber: _parseChapterNumber(json),
      publishedAt: _parsePublishedAt(json),
    );
  }

  static String _parseId(Map<String, dynamic> json) {
    return (json['id'] ??
                json['_id'] ??
                json['chapter_id'] ??
                json['chapterId'])
            ?.toString() ??
        '';
  }

  static String _parseTitle(Map<String, dynamic> json) {
    return (json['title'] ?? json['name'] ?? json['chapter_title'])
            ?.toString() ??
        '';
  }

  static int? _parseChapterNumber(Map<String, dynamic> json) {
    final chapterNum = json['chapter'] ?? json['chapter_number'];
    if (chapterNum != null) {
      return int.tryParse(chapterNum.toString());
    }
    return null;
  }

  static DateTime? _parsePublishedAt(Map<String, dynamic> json) {
    try {
      final dateStr = json['created_at'] ?? json['published_at'];
      if (dateStr != null) {
        return DateTime.tryParse(dateStr.toString());
      }
    } catch (_) {
      // ignore parse errors
    }
    return null;
  }

  static List<String> _parseImages(Map<String, dynamic> json) {
    final rawImages = json['images'] ?? json['pages'] ?? json['content'] ?? [];
    if (rawImages is List) {
      return rawImages
          .map(_parseImageItem)
          .where((url) => url.isNotEmpty)
          .toList();
    }
    return [];
  }

  static String _parseImageItem(dynamic img) {
    if (img is String) return img;
    if (img is Map) {
      return (img['url'] ??
              img['src'] ??
              img['path'] ??
              img['file'] ??
              img['image'] ??
              img['link'] ??
              '')
          .toString();
    }
    return img.toString();
  }
}
