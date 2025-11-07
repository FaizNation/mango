import 'package:mango/models/chapter.dart';
import 'package:mango/models/comic/manga.dart';
import 'package:mango/models/comic/manhwa.dart';
import 'package:mango/models/comic/manhua.dart';

// Utility to normalize API "type" fields across different providers.
String? normalizeType(dynamic t) {
  if (t == null) return null;
  if (t is String) return t;
  if (t is Map) return (t['name'] ?? t['type'] ?? t['nama'])?.toString();
  if (t is List && t.isNotEmpty) return normalizeType(t.first);
  return t.toString();
}

/// Base class for all comic types (manga, manhwa, manhua)
/// Encapsulates common fields and provides a hook for subclasses
/// to expose additional information via `getAdditionalInfo()`.
 class Comic {
  final String id;
  final String title;
  final String? titleEnglish;
  final String? synopsis;
  final String imageUrl;
  final List<String> genres;
  // final double rating;
  final String? status;
  final int? chapters;
  final List<Chapter> availableChapters;
  final String? author;
  final String? type;

  Comic({
    required this.id,
    required this.title,
    this.titleEnglish,
    this.synopsis,
    required this.imageUrl,
    required this.genres,
    // required this.rating,
    this.status,
    this.chapters,
    this.availableChapters = const [],
    this.author,
    this.type,
  });

  /// Return a map of additional info for UI/detail screens.
  /// Subclasses should override and include `...super.getAdditionalInfo()`.
  Map<String, dynamic> getAdditionalInfo() {
    return {
      // 'Title': title,
      // if (author != null) 'Author': author,
      // if (genres.isNotEmpty) 'Genres': genres.join(', '),
      // if (rating != 0.0) 'Rating': rating,
      if (status != null) 'Status': status,
      if (type != null) 'Type': type,
    };
  }

  /// Factory that dispatches to the correct subclass based on API data.
  factory Comic.fromApi(Map<String, dynamic> json) {
    String? t = normalizeType(
      json['type'] ?? json['comic_type'] ?? json['jenis'] ?? json['type_name'],
    );
    if (t != null) {
      final low = t.toLowerCase();
      if (low.contains('manhwa')) return Manhwa.fromApi(json);
      if (low.contains('manhua')) return Manhua.fromApi(json);
      if (low.contains('manga')) return Manga.fromApi(json);
    }

    // Some APIs don't set a clear type field — attempt to infer from keys
    final keys = json.keys.map((k) => k.toString().toLowerCase()).toList();
    if (keys.contains('reading_direction') ||
        keys.contains('readingdirection')) {
      return Manhwa.fromApi(json);
    }

    if (keys.contains('is_colored') || keys.contains('colored')) {
      return Manhua.fromApi(json);
    }

    // Fallback default: Manga
    return Manga.fromApi(json);
  }
}
