import 'package:mango/models/comic.dart';

class Manga extends Comic {
  final String _readingDirection = "Right-to-Left";

  Manga({
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

  String get readingDirection => _readingDirection;

  @override
  Map<String, dynamic> getAdditionalInfo() {
    return {
      ...super.getAdditionalInfo(),
      'Origin': 'Japan 📍',
      'Reading Direction': _readingDirection,
    };
  }

  @override
  String getType() => 'Manga';
}
