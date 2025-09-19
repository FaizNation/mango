import 'package:mango/models/comic.dart';

class Manhua extends Comic {
  final bool _isColored = true;

  Manhua({
    required super.id,
    required super.title,
    required super.author,
    required super.description,
    required super.coverImage,
    required super.rating,
    required super.genres,
    super.status,
    super.chapters,
    super.releaseYear,
  });

  bool get isColored => _isColored;

  @override
  Map<String, dynamic> getAdditionalInfo() {
    return {
      ...super.getAdditionalInfo(),
      'Origin': 'China 🇨🇳',
      'isColored': true,
    };
  }

  @override
  String getType() => 'Manhua';
}
