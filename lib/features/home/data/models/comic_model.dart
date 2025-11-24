import 'package:mango/features/home/domain/entities/comic_entity.dart';

String? _normalizeType(dynamic t) {
    if (t == null) return null;
    if (t is String) return t;
    if (t is Map) return (t['name'] ?? t['type'] ?? t['nama'])?.toString();
    if (t is List && t.isNotEmpty) return _normalizeType(t.first);
    return t.toString();
}

class ComicModel extends ComicEntity {
  const ComicModel({
    required super.id,
    required super.title,
    required super.imageUrl,
    super.type,
    super.synopsis,
    super.author,
    super.genres = const [],
  });

  factory ComicModel.fromApi(Map<String, dynamic> json) {
    final id = (json['id'] ?? json['endpoint'])?.toString() ?? '';
    final title = (json['title'])?.toString() ?? 'No Title';
    
    final imageUrl = 
        json['image_url']?.toString() ?? 
        json['image']?.toString() ?? 
        json['thumb']?.toString() ?? 
        json['cover_image']?.toString() ?? 
        '';

    final type = _normalizeType(
      json['type'] ?? json['comic_type'] ?? json['jenis'] ?? json['type_name']
    );

    final synopsis = (json['description'] ?? json['synopsis'])?.toString();
    final author = (json['author'])?.toString();

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

    return ComicModel(
      id: id,
      title: title,
      imageUrl: imageUrl,
      type: type,
      synopsis: synopsis,
      author: author,
      genres: genres,
    );
  }
}
