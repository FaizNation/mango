import 'package:mango/models/comic.dart';

class Manhwa extends Comic {
  final String _readingDirection = "Top-to-Bottom";

  Manhwa({
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
      'Origin': 'Korea 🇰🇷',
      'Reading Direction': _readingDirection,
    };
  }

  @override
  String getType() => 'Manhwa';
}
