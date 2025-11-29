import 'dart:async';
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
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
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
