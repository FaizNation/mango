import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mango/features/home/domain/entities/comic_entity.dart';

class FavoriteComicModel extends ComicEntity {
  const FavoriteComicModel({
    required super.id,
    required super.title,
    required super.imageUrl,
    super.type,
    super.synopsis,
    super.author,
    super.genres,
  });

  factory FavoriteComicModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FavoriteComicModel(
      id: doc.id,
      title: data['title'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      type: data['type'],
      synopsis: data['synopsis'],
      author: data['author'],
      genres: List<String>.from(data['genres'] ?? []),
    );
  }

  static Map<String, dynamic> toFirestore(ComicEntity comic) {
    return {
      'id': comic.id,
      'title': comic.title,
      'imageUrl': comic.imageUrl,
      'type': comic.type,
      'synopsis': comic.synopsis,
      'author': comic.author,
      'genres': comic.genres,
      'addedAt': FieldValue.serverTimestamp(),
    };
  }
}
