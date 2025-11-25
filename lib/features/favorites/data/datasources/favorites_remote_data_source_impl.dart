import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mango/core/error/exceptions.dart';
import 'package:mango/features/favorites/data/datasources/favorites_remote_data_source.dart';
import 'package:mango/features/favorites/data/models/favorite_comic_model.dart';
import 'package:mango/features/home/domain/entities/comic_entity.dart';

class FavoritesRemoteDataSourceImpl implements FavoritesRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  FavoritesRemoteDataSourceImpl({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
  })  : _firebaseAuth = firebaseAuth,
        _firestore = firestore;

  @override
  Stream<List<FavoriteComicModel>> getFavorites() {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw ServerException('User is not logged in.');
    }
    try {
      return _firestore
          .collection('users')
          .doc(user.uid)
          .collection('favorites')
          .orderBy('addedAt', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) => FavoriteComicModel.fromFirestore(doc)).toList();
      });
    } catch (e) {
      throw ServerException('Failed to fetch favorites: $e');
    }
  }

  @override
  Future<void> addFavorite(ComicEntity comic) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw ServerException('User is not logged in.');
    }
    try {
      final docRef = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('favorites')
          .doc(comic.id);
      await docRef.set(FavoriteComicModel.toFirestore(comic));
    } catch (e) {
      throw ServerException('Failed to add favorite: $e');
    }
  }

  @override
  Future<void> removeFavorite(String comicId) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw ServerException('User is not logged in.');
    }
    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('favorites')
          .doc(comicId)
          .delete();
    } catch (e) {
      throw ServerException('Failed to remove favorite: $e');
    }
  }
}
