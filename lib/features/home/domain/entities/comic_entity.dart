import 'package:equatable/equatable.dart';

class ComicEntity extends Equatable {
  final String id;
  final String title;
  final String imageUrl;
  final String? type;
  final String? synopsis;
  final String? author;
  final List<String> genres;

  const ComicEntity({
    required this.id,
    required this.title,
    required this.imageUrl,
    this.type,
    this.synopsis,
    this.author,
    this.genres = const [],
  });

  @override
  List<Object?> get props => [id, title, imageUrl, type, synopsis, author, genres];
}
