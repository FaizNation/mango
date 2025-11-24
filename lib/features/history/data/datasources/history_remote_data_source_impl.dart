import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mango/core/error/exceptions.dart';
import 'package:mango/features/history/data/datasources/history_remote_data_source.dart';
import 'package:mango/features/history/data/models/history_entry_model.dart';
import 'package:mango/features/home/domain/entities/comic_entity.dart';

class HistoryRemoteDataSourceImpl implements HistoryRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  HistoryRemoteDataSourceImpl({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
  })  : _firebaseAuth = firebaseAuth,
        _firestore = firestore;

  @override
  Stream<List<HistoryEntryModel>> getHistory() {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw ServerException('User is not logged in.');
    }
    try {
      return _firestore
          .collection('users')
          .doc(user.uid)
          .collection('history')
          .orderBy('openedAt', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) => HistoryEntryModel.fromFirestore(doc)).toList();
      });
    } catch (e) {
      throw ServerException('Failed to fetch history: $e');
    }
  }

  @override
  Future<void> addHistoryEntry(ComicEntity comic) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw ServerException('User is not logged in.');
    }
    try {
      final docRef = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('history')
          .doc(comic.id);
      await docRef.set(HistoryEntryModel.toFirestore(comic));
    } catch (e) {
      throw ServerException('Failed to add history entry: $e');
    }
  }

  @override
  Future<void> deleteHistoryEntry(String id) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw ServerException('User is not logged in.');
    }
    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('history')
          .doc(id)
          .delete();
    } catch (e) {
      throw ServerException('Failed to delete history entry: $e');
    }
  }
  
  @override
  Future<void> clearAllHistory() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw ServerException('User is not logged in.');
    }
    try {
      final coll = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('history');
      final snap = await coll.get();
      final batch = _firestore.batch();
      for (final d in snap.docs) {
        batch.delete(d.reference);
      }
      await batch.commit();
    } catch (e) {
      throw ServerException('Failed to clear history: $e');
    }
  }
}
