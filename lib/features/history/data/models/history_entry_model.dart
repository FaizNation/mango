import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mango/features/history/domain/entities/history_entry_entity.dart';
import 'package:mango/features/home/domain/entities/comic_entity.dart';

class HistoryEntryModel extends HistoryEntryEntity {
  const HistoryEntryModel({
    required super.id,
    required super.title,
    super.author,
    super.coverImage,
    super.description,
    super.openedAt,
    super.genres,
  });

  factory HistoryEntryModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final ts = data['openedAt'];
    DateTime? opened;
    if (ts is Timestamp) opened = ts.toDate();
    
    return HistoryEntryModel(
      id: doc.id,
      title: data['title'] as String? ?? 'Untitled',
      author: data['author'] as String?,
      coverImage: data['coverImage'] as String?,
      description: data['description'] as String?,
      openedAt: opened,
      genres: List<String>.from(data['genres'] ?? []),
    );
  }

  static Map<String, dynamic> toFirestore(ComicEntity comic) {
    return {
      'comicId': comic.id,
      'title': comic.title,
      'author': comic.author,
      'description': comic.synopsis,
      'coverImage': comic.imageUrl,
      'genres': comic.genres,
      'openedAt': FieldValue.serverTimestamp(),
    };
  }
}
