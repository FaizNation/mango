import 'package:mango/models/comic/comic.dart';
import 'package:mango/utils/image_proxy.dart';

class Manhua extends Comic {
  final bool isColored;
  final String origin;

  Manhua({
    required super.id,
    required super.title,
    super.titleEnglish,
    super.synopsis,
    required super.imageUrl,
    required super.genres,
    // required super.rating,
    super.status,
    super.chapters,
    super.availableChapters,
    super.author,
    super.type,
    this.isColored = true,
    this.origin = 'China 🇨🇳',
  });

  @override
  Map<String, dynamic> getAdditionalInfo() {
    return {
      ...super.getAdditionalInfo(),
      'Origin': origin,
      'isColored': isColored,
    };
  }

  factory Manhua.fromApi(Map<String, dynamic> json) {
    final id =
        (json['id'] ?? json['_id'] ?? json['comic_id'] ?? json['slug'])
            ?.toString() ??
        '';
    final title = (json['title'] ?? json['name'] ?? json['judul'] ?? '')
        .toString();
    final image = (json['cover_image'])?.toString() ?? '';
    final synopsis = (json['synopsis'] ?? json['description'])?.toString();

    List<String> genres = [];
    final g = json['genres'] ?? json['genre'];
    if (g is List) {
      genres = g
          .map((e) => e is Map ? (e['name'] ?? '').toString() : e.toString())
          .where((s) => s.isNotEmpty)
          .toList();
    } else if (g is String) {
      genres = g
          .split(',')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();
    }

    // double rating = 0.0;
    // try {
    //   final r = json['rating'] ?? json['score'] ?? json['rate'];
    //   if (r != null) rating = double.tryParse(r.toString()) ?? 0.0;
    // } catch (_) {}

    final author = (json['author'] ?? json['pengarang'] ?? json['artist'])
        ?.toString();
    final type = normalizeType(json['type'] ?? json['comic_type']);
    final coloredRaw = json['is_colored'] ?? json['colored'];
    bool colored;
    if (coloredRaw == null) {
      colored = true;
    } else if (coloredRaw is bool) {
      colored = coloredRaw;
    } else {
      colored = coloredRaw.toString().toLowerCase() == 'true';
    }

    return Manhua(
      id: id,
      title: title,
      titleEnglish: null,
      synopsis: synopsis,
      imageUrl: ImageProxy.proxy(image),
      genres: genres,
      // rating: rating,
      status: json['status']?.toString(),
      chapters: json['chapter_count'] is int
          ? json['chapter_count'] as int
          : int.tryParse(json['chapters']?.toString() ?? ''),
      availableChapters: [],
      author: author,
      type: type,
      isColored: colored,
    );
  }
}
