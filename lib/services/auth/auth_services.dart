import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mango/models/users.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> signInWithEmail(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return cred;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Authentication failed');
    }
  }

  Future<UserCredential> signUpWithEmail(
    String email,
    String password, {
    String? displayName,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = cred.user;
      if (user != null && displayName != null && displayName.isNotEmpty) {
        await user.updateDisplayName(displayName);
        await user.reload();
      }

      try {
        final uid = user?.uid;
        if (uid != null) {
          final userModel = UserModel(
            uid: uid,
            email: email,
            displayName: displayName ?? user?.displayName ?? '',
            photoUrl: user?.photoURL,
            createdAt: DateTime.now(),
          );

          await FirebaseFirestore.instance.collection('users').doc(uid).set({
            ...userModel.toMap(),
            'createdAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
        }
      } on FirebaseException catch (fireErr) {
        throw Exception(
          'Registration succeeded but saving profile failed: ${fireErr.message}',
        );
      } catch (fireErr) {
        throw Exception(
          'Registration succeeded but saving profile failed: $fireErr',
        );
      }

      return cred;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Registration failed');
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  User? get currentUser => _auth.currentUser;
}
