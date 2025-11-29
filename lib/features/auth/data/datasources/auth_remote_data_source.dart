import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:mango/core/error/exceptions.dart';

abstract class AuthRemoteDataSource {
  Stream<auth.User?> get user;

  /// Throws a [ServerException] for all error codes.
  Future<void> signInWithEmail({
    required String email,
    required String password,
  });

  /// Throws a [ServerException] for all error codes.
  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  });

  /// Throws a [ServerException] for all error codes.
  Future<void> signOut();
}
