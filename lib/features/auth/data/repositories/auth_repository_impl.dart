import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mango/core/error/exceptions.dart';
import 'package:mango/core/error/failure.dart';
import 'package:mango/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:mango/features/auth/data/models/user_model.dart';
import 'package:mango/features/auth/domain/entities/user_entity.dart';
import 'package:mango/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final FirebaseFirestore _firestore;

  AuthRepositoryImpl({required this.remoteDataSource, required FirebaseFirestore firestore}) : _firestore = firestore;

  @override
  Stream<UserEntity?> get user {
    return remoteDataSource.user.asyncMap((firebaseUser) async {
      if (firebaseUser == null) {
        return null;
      }
      // The firebaseUser from authStateChanges doesn't have all the info.
      // We need to fetch our user document from Firestore.
      final userDoc = await _firestore.collection('users').doc(firebaseUser.uid).get();
      if (userDoc.exists) {
        return UserModel.fromFirestore(userDoc);
      }
      // This might happen if user is created but firestore doc fails.
      // We can return a basic entity from the auth user.
      return UserModel.fromFirebaseAuthUser(firebaseUser);
    });
  }

  @override
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      await remoteDataSource.signInWithEmail(email: email, password: password);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      await remoteDataSource.signUpWithEmail(
        email: email,
        password: password,
        displayName: displayName,
      );
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await remoteDataSource.signOut();
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }
}
