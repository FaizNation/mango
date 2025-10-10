import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/history_entry.dart';

class HistoryProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _sub;
  List<HistoryEntry> _entries = [];

  HistoryProvider({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _auth = auth ?? FirebaseAuth.instance {
    _init();
  }

  List<HistoryEntry> get entries => List.unmodifiable(_entries);

  void _init() {
    final user = _auth.currentUser;
    if (user == null) return;
    _sub?.cancel();
    _sub = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('history')
        .orderBy('openedAt', descending: true)
        .snapshots()
        .listen((snap) {
          _entries = snap.docs.map((d) => HistoryEntry.fromDoc(d)).toList();
          notifyListeners();
        });
  }

  Future<void> refresh() async {
    _init();
  }

  Future<void> addEntry({
    required String id,
    required String title,
    String? author,
    String? coverImage,
    String? description,
    Map<String, dynamic>? extra,
    required double rating,
    required List<String> genres,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;
    final docRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('history')
        .doc(id);
    final Map<String, dynamic> data = {
      'title': title,
      if (author != null) 'author': author,
      if (coverImage != null) 'coverImage': coverImage,
      if (description != null) 'description': description,
      'rating': rating,
      if (genres.isNotEmpty) 'genres': genres,

    };
    if (extra != null) data.addAll(extra);
    await docRef.set({
      ...data,
      'openedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> delete(String id) async {
    final user = _auth.currentUser;
    if (user == null) return;
    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('history')
        .doc(id)
        .delete();
  }

  Future<void> clearAll() async {
    final user = _auth.currentUser;
    if (user == null) return;
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
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
