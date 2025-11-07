import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/comic/comic.dart';

class FavoritesProvider extends ChangeNotifier {
  final List<Comic> _favorites = [];
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  StreamSubscription<QuerySnapshot>? _subscription;
  StreamSubscription<User?>? _authSubscription;

  FavoritesProvider({FirebaseAuth? auth, FirebaseFirestore? firestore})
    : _auth = auth ?? FirebaseAuth.instance,
      _firestore = firestore ?? FirebaseFirestore.instance {
    _authSubscription = _auth.authStateChanges().listen((user) {
      if (user == null) {
        _subscription?.cancel();
        _favorites.clear();
        notifyListeners();
      } else {
        _initializeListener();
      }
    });
    _initializeListener();
  }

  List<Comic> get favorites => List.unmodifiable(_favorites);

  bool isFavorite(Comic comic) {
    return _favorites.any((element) => element.id == comic.id);
  }

  void _initializeListener() {
    final user = _auth.currentUser;
    if (user == null) {
      _favorites.clear();
      notifyListeners();
      return;
    }

    // Listen to favorites collection
    _subscription?.cancel();
    _subscription = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .snapshots()
        .listen(
          (snapshot) {
            _favorites.clear();
            for (var doc in snapshot.docs) {
              final data = doc.data();
              // Use fromFirestore factory which is specifically designed for Firestore document shape
              final comic = Comic.fromFirestore(data, doc.id);
              _favorites.add(comic);
            }
            notifyListeners();
          },
          onError: (error) {
            debugPrint('Error fetching favorites: $error');
          },
        );
  }

  Future<void> toggleFavorite(Comic comic) async {
    final user = _auth.currentUser;
    if (user == null) {
      debugPrint('Cannot toggle favorite: User not signed in');
      return;
    }

    final docRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .doc(comic.id);

    try {
      if (isFavorite(comic)) {
        await docRef.delete();
      } else {
        await docRef.set({
          'id': comic.id,
          'title': comic.title,
          'titleEnglish': comic.titleEnglish,
          'author': comic.author,
          'synopsis': comic.synopsis,
          'imageUrl': comic.imageUrl,
          'genres': comic.genres,
          'addedAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      debugPrint('Error toggling favorite: $e');
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _authSubscription?.cancel();
    super.dispose();
  }
}
