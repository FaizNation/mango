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

  factory Manga.fromFirestore(Map<String, dynamic> data, String docId) {
    return Manga(
      id: data['id'] ?? docId,
      title: data['title'] ?? '',
      titleEnglish: data['titleEnglish'],
      synopsis: data['synopsis'],
      imageUrl: data['imageUrl'] ?? '',
      genres:
          (data['genres'] as List?)?.map((e) => e.toString()).toList() ?? [],
      status: data['status'],
      chapters: data['chapters'],
      author: data['author'],
      type: data['type'],
      readingDirection: data['readingDirection'] ?? 'Right to Left',
      origin: data['origin'] ?? 'Japan 🇯🇵',
      availableChapters: const [],
    );
  }

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

    final author = (json['author'])?.toString();
    final type = normalizeType(json['type'] ?? json['comic_type']);

    return Manga(
      id: id,
      title: title,
      titleEnglish: null,
      synopsis: synopsis,
      imageUrl: ImageProxy.proxy(image),
      genres: genres,

      status: json['status']?.toString(),
      chapters: json['chapter_count'] is int
          ? json['chapter_count'] as int
          : json['chapters'] is int
          ? json['chapters'] as int
          : int.tryParse(json['chapters']?.toString() ?? ''),
      availableChapters: [],
      author: author,
      type: type,
    );
  }
}
