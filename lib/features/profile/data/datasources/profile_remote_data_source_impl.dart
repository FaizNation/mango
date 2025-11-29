import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mango/core/error/exceptions.dart';
import 'package:mango/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:mime/mime.dart';

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  ProfileRemoteDataSourceImpl({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
  })  : _firebaseAuth = firebaseAuth,
        _firestore = firestore;

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null || user.email == null) {
        throw ServerException("No user is currently logged in.");
      }

      final cred = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword.trim(),
      );
      await user.reauthenticateWithCredential(cred);
      await user.updatePassword(newPassword.trim());
    } on FirebaseAuthException catch (e) {
      throw ServerException(e.message ?? "An unknown auth error occurred.");
    }
  }

  @override
  Future<String> updateProfilePhoto(Uint8List imageBytes) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw ServerException('Not signed in');
      }

      final mimeType = lookupMimeType('', headerBytes: imageBytes) ?? 'image/jpeg';
      final dataUri = 'data:$mimeType;base64,${base64Encode(imageBytes)}';

      await _firestore.collection('users').doc(user.uid).set({
        'photoUrl': dataUri,
      }, SetOptions(merge: true));
      
      return dataUri;

    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Failed to update photo');
    }
  }
}
