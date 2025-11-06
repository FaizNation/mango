import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/comic/comic.dart';

class FavoritesProvider extends ChangeNotifier {
  final List<Comic> _favorites = [];

  FavoritesProvider() {
    _loadFavoritesFromFirestore();
  }

  List<Comic> get favorites => List.unmodifiable(_favorites);

  bool isFavorite(Comic comic) {
    return _favorites.any((element) => element.id == comic.id);
  }

  Future<void> toggleFavorite(Comic comic) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Not authenticated — just update local state
      _localToggle(comic);
      return;
    }

    final uid = user.uid;
    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('favorites')
        .doc(comic.id);

    if (isFavorite(comic)) {
      // remove
      _favorites.removeWhere((element) => element.id == comic.id);
      notifyListeners();
      try {
        await docRef.delete();
      } catch (_) {
        // ignore firestore errors for now
      }
    } else {
      // add
      _favorites.add(comic);
      notifyListeners();
      try {
        await docRef.set({
          'id': comic.id,
          'title': comic.title,
          'titleEnglish': comic.titleEnglish,
          'author': comic.author,
          'synopsis': comic.synopsis,
          'imageUrl': comic.imageUrl,
          // 'rating': comic.rating,
          'genres': comic.genres,
          // 'chapters': comic.chapters,
          // 'status': comic.status,
          // 'type': comic.type,
          'addedAt': FieldValue.serverTimestamp(),
        });
      } catch (_) {
        // ignore firestore errors for now
      }
    }
  }

  void _localToggle(Comic comic) {
    if (isFavorite(comic)) {
      _favorites.removeWhere((element) => element.id == comic.id);
    } else {
      _favorites.add(comic);
    }
    notifyListeners();
  }

  Future<void> _loadFavoritesFromFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('favorites')
          .get();
      final docs = snapshot.docs;
      _favorites.clear();
      for (final doc in docs) {
        final data = doc.data();
        final id = data['id']?.toString() ?? doc.id;
        final title = data['title'] as String? ?? '';
        final titleEnglish = data['titleEnglish'] as String?;
        final author = data['author'] as String?;
        final synopsis = data['synopsis'] as String?;
        final imageUrl = data['imageUrl'] as String? ?? '';
        // final rating = (data['rating'] as num?)?.toDouble() ?? 0.0;
        final genres =
            (data['genres'] as List?)?.map((e) => e.toString()).toList() ??
            <String>[];
        // final chapters = data['chapters'] is int
        //     ? data['chapters'] as int
        //     : int.tryParse(data['chapters']?.toString() ?? '');
        // final status = data['status'] as String?;

        // final type = data['type'] as String?;
        final comic = Comic.fromApi({
          'id': id,
          'title': title,
          'titleEnglish': titleEnglish,
          'author': author,
          'synopsis': synopsis,
          'imageUrl': imageUrl,
          // 'rating': rating,
          'genres': genres,
          // 'chapters': chapters,
          // 'status': status,
          // 'type': type,
        });
        _favorites.add(comic);
      }
      notifyListeners();
    } catch (e) {
      // ignore load errors
    }
  }
}
