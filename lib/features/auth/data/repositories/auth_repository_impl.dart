import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mango/core/error/exceptions.dart';
import 'package:mango/core/error/failure.dart';
import 'package:mango/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:mango/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:mango/features/auth/data/models/user_model.dart';
import 'package:mango/features/auth/domain/entities/user_entity.dart';
import 'package:mango/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final FirebaseFirestore _firestore;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  @override
  Stream<UserEntity?> get user {
    return remoteDataSource.user.switchMap((firebaseUser) {
      if (firebaseUser == null) {
        return Stream.value(null);
      }
      return _firestore.collection('users').doc(firebaseUser.uid).snapshots().map((snapshot) {
        if (snapshot.exists) {
          return UserModel.fromFirestore(snapshot);
        }
        return UserModel.fromFirebaseAuthUser(firebaseUser);
      });
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
      await localDataSource.clearUserSession();
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } on CacheException catch (e) {
      throw CacheFailure(e.message);
    }
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    try {
      final firebaseUser = remoteDataSource.getCurrentUser();
      if (firebaseUser == null) {
        return null;
      }

      // Try to get user data from Firestore
      final userDoc = await _firestore.collection('users').doc(firebaseUser.uid).get();
      if (userDoc.exists) {
        return UserModel.fromFirestore(userDoc);
      }

      // Fallback to Firebase Auth user data
      return UserModel.fromFirebaseAuthUser(firebaseUser);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure('Failed to get current user: $e');
    }
  }

  @override
  Future<void> saveUserSession(UserEntity user) async {
    try {
      final userModel = UserModel(
        uid: user.uid,
        email: user.email,
        displayName: user.displayName,
        photoUrl: user.photoUrl,
        createdAt: user.createdAt,
      );
      await localDataSource.saveUserSession(userModel);
    } on CacheException catch (e) {
      throw CacheFailure(e.message);
    }
  }

  @override
  Future<void> clearUserSession() async {
    try {
      await localDataSource.clearUserSession();
    } on CacheException catch (e) {
      throw CacheFailure(e.message);
    }
  }
}

extension StreamSwitchMap<T> on Stream<T> {
  Stream<E> switchMap<E>(Stream<E> Function(T event) convert) {
    var controller = StreamController<E>();
    StreamSubscription<T>? outerSubscription;
    StreamSubscription<E>? innerSubscription;

    controller.onListen = () {
      outerSubscription = listen(
        (event) {
          innerSubscription?.cancel();
          innerSubscription = convert(event).listen(
            controller.add,
            onError: controller.addError,
            onDone: () {
              // Don't close controller, outer stream is still active
            },
          );
        },
        onError: controller.addError,
        onDone: controller.close,
      );
    };

    controller.onCancel = () {
      outerSubscription?.cancel();
      innerSubscription?.cancel();
    };

    return controller.stream;
  }
}
