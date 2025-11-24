import 'package:equatable/equatable.dart';

class HistoryEntryEntity extends Equatable {
  final String id; // doc id (usually comicId)
  final String title;
  final String? author;
  final String? coverImage;
  final String? description;
  final DateTime? openedAt;
  final List<String> genres;

  const HistoryEntryEntity({
    required this.id,
    required this.title,
    this.author,
    this.coverImage,
    this.description,
    this.openedAt,
    this.genres = const [],
  });

  @override
  List<Object?> get props => [id, title, author, coverImage, description, openedAt, genres];
}
