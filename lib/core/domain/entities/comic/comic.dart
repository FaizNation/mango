import 'package:mango/core/domain/entities/chapter.dart';

String? normalizeType(dynamic t) {
  if (t == null) return null;
  if (t is String) return t;
  if (t is Map) return (t['name'] ?? t['type'] ?? t['nama'])?.toString();
  if (t is List && t.isNotEmpty) return normalizeType(t.first);
  return t.toString();
}

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

  factory Comic.fromApi(Map<String, dynamic> json) {
    final id = (json['id'] ?? json['endpoint'])?.toString() ?? '';
    final title = (json['title'])?.toString() ?? 'No Title';

    final imageUrl =
        json['image_url']?.toString() ??
        json['image']?.toString() ??
        json['thumb']?.toString() ??
        json['cover_image']?.toString() ??
        '';

    final type = normalizeType(json['type'] ?? json['comic_type']);

    final synopsis = (json['description'] ?? json['synopsis'])?.toString();
    final author = (json['author'])?.toString();

    List<String> genres = [];
    final g = json['genres'] ?? json['genre'] ?? json['genres_list'];
    if (g is List) {
      genres = g
          .map(
            (e) => e is Map
                ? (e['name'] ?? e['genre'] ?? e['title'] ?? '').toString()
                : e.toString(),
          )
          .where((s) => s.isNotEmpty)
          .toList();
    } else if (g is String) {
      genres = g
          .split(',')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();
    }

    return Comic(
      id: id,
      title: title,
      titleEnglish: null,
      synopsis: synopsis,
      imageUrl: imageUrl,
      genres: genres,
      status: json['status']?.toString(),
      chapters: json['chapter_count'] is int
          ? json['chapter_count'] as int
          : json['chapters'] is int
          ? json['chapters'] as int
          : int.tryParse(json['chapters']?.toString() ?? ''),
      availableChapters: const [],
      author: author,
      type: type,
    );
  }
}
