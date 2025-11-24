import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:mango/core/error/exceptions.dart';
import 'package:mango/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:mango/features/auth/data/models/user_model.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final auth.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRemoteDataSourceImpl({
    required auth.FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
  })  : _firebaseAuth = firebaseAuth,
        _firestore = firestore;

  @override
  Stream<auth.User?> get user => _firebaseAuth.authStateChanges();

  @override
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on auth.FirebaseAuthException catch (e) {
      throw ServerException(e.message ?? 'Login failed');
    }
  }

  @override
  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final cred = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebaseUser = cred.user;
      if (firebaseUser == null) {
        throw ServerException('Sign up failed: User not created.');
      }
      
      await firebaseUser.updateDisplayName(displayName);

      final userModel = UserModel(
        uid: firebaseUser.uid,
        email: email,
        displayName: displayName,
        photoUrl: firebaseUser.photoURL,
        createdAt: DateTime.now(),
      );

      await _firestore.collection('users').doc(firebaseUser.uid).set(
        userModel.toMap(),
        SetOptions(merge: true),
      );

    } on auth.FirebaseAuthException catch (e) {
      throw ServerException(e.message ?? 'Registration failed');
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Saving profile failed');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw ServerException('Sign out failed');
    }
  }
}
