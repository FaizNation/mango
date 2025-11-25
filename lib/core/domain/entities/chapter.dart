import 'package:mango/core/utils/image_proxy.dart';

class Chapter {
  final String id;
  final String title;
  final String comicId; // keep as string to match API ids
  final List<String> images;
  final int? chapterNumber;
  final DateTime? publishedAt;

  Chapter({
    required this.id,
    required this.title,
    required this.comicId,
    required this.images,
    this.chapterNumber,
    this.publishedAt,
  });

  /// Membuat salinan Chapter dengan list gambar kosong.
  /// Berguna untuk menampilkan daftar chapter tanpa memuat gambar.
  factory Chapter.fromChapterSummary(Chapter chapter, String comicId) {
    return Chapter(
      id: chapter.id, // Lebih aman menggunakan id asli
      title: chapter.title,
      comicId: comicId,
      images: [], // Images will be loaded when chapter is opened
      chapterNumber: chapter.chapterNumber,
      publishedAt: chapter.publishedAt,
    );
  }

  /// Mem-parsing chapter yang dikembalikan oleh API (dengan berbagai format)
  factory Chapter.fromApi(Map<String, dynamic> json, String comicId) {
    return Chapter(
      id: _parseId(json),
      title: _parseTitle(json),
      comicId: comicId,
      images: ImageProxy.proxyList(_parseImages(json)),
      chapterNumber: _parseChapterNumber(json),
      publishedAt: _parsePublishedAt(json),
    );
  }

  // --- Private Static Parsers for fromApi ---

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
          .map(_parseImageItem) // Gunakan helper untuk mem-parsing item
          .where((url) => url.isNotEmpty)
          .toList();
    }
    return [];
  }

  /// Helper untuk mem-parsing satu item gambar (yang bisa jadi String atau Map)
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
    // Fallback untuk tipe data tak terduga (misal: int, dll)
    return img.toString(); 
  }
}