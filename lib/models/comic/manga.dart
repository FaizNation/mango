import 'package:mango/models/comic/comic.dart';
import 'package:mango/utils/image_proxy.dart';

class Manga extends Comic {
  final String readingDirection;
  final String origin;

  Manga({
    required super.id,
    required super.title,
    super.titleEnglish,
    super.synopsis,
    required super.imageUrl,
    required super.genres,
    required super.rating,
    super.status,
    super.chapters,
    super.availableChapters,
    super.author,
    super.type,
    this.readingDirection = 'Right to Left',
    this.origin = 'Japan 🇯🇵',
  });

  @override
  Map<String, dynamic> getAdditionalInfo() {
    return {
      ...super.getAdditionalInfo(),
      'Origin': origin,
      'Reading Direction': readingDirection,
    };
  }

  // // Original Jikan factory kept for compatibility
  // factory Manga.fromApi(Map<String, dynamic> json) {
  //   final idVal = json['mal_id'] ?? json['id'];
  //   return Manga(
  //     id: idVal?.toString() ?? '',
  //     title: json['title'] ?? '',
  //     titleEnglish: json['title_english'],
  //     synopsis: json['synopsis'],
  //     imageUrl:
  //         json['images']?['jpg']?['large_image_url'] ??
  //         json['images']?['jpg']?['image_url'] ??
  //         '',
  //     genres:
  //         (json['genres'] as List?)
  //             ?.map((g) => g['name'].toString())
  //             .toList() ??
  //         [],
  //     rating: (json['score'] ?? 0.0).toDouble(),
  //     status: json['status'],
  //     chapters: json['chapters'],
  //     author: (json['authors'] as List?)?.isNotEmpty == true
  //         ? '${json['authors'][0]['name']}'
  //         : null,
  //     availableChapters: [],
  //   );
  // }

  // Factory for the komiku-faiznation API (and similar)
  factory Manga.fromApi(Map<String, dynamic> json) {
    final id = (json['id'])?.toString() ?? '';
    final title = (json['title']).toString();
    final image = (json['cover_image'])?.toString() ?? '';
    final synopsis = (json['description'])?.toString();

    List<String> genres = [];
    final g = json['genres'] ?? json['genre'] ?? json['genres_list'];
    if (g is List) {
      genres = g
          .map(
            (e) => e is Map
                ? (e['name'] ?? e['genre'] ?? e['title'] ?? e['name'] ?? '')
                      .toString()
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

    double rating = 0.0;
    try {
      final r = json['rating'] ?? json['score'] ?? json['rate'];
      if (r != null) rating = double.tryParse(r.toString()) ?? 0.0;
    } catch (_) {}
    final author = (json['author'])?.toString();
    final type = normalizeType(json['type'] ?? json['comic_type']);

    return Manga(
      id: id,
      title: title,
      titleEnglish: null,
      synopsis: synopsis,
      imageUrl: ImageProxy.proxy(image),
      genres: genres,
      rating: rating,
      status: json['status']?.toString(),
      chapters: json['chapter_count'] is int
          ? json['chapter_count'] as int
          : json['chapters'] is int
          ? json['chapters'] as int
          : int.tryParse(json['chapters']?.toString() ?? ''),
      availableChapters: [],
      author: author,
      type: type,
      // readingDirection and origin are set by default, not from API
    );
  }
}
