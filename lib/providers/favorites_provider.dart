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
          'author': comic.author,
          'description': comic.description,
          'coverImage': comic.coverImage,
          'rating': comic.rating,
          'genres': comic.genres,
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
        final id = data['id'] as String? ?? doc.id;
        final title = data['title'] as String? ?? '';
        final author = data['author'] as String? ?? '';
        final description = data['description'] as String? ?? '';
        final coverImage = data['coverImage'] as String? ?? '';
        final rating = (data['rating'] as num?)?.toDouble() ?? 0.0;
        final genres =
            (data['genres'] as List?)?.map((e) => e.toString()).toList() ??
            <String>[];

        _favorites.add(
          Comic(
            id: id,
            title: title,
            author: author,
            description: description,
            coverImage: coverImage,
            rating: rating,
            genres: genres,
          ),
        );
      }
      notifyListeners();
    } catch (e) {
      // ignore load errors
    }
  }
}
