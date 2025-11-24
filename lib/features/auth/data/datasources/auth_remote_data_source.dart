import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:mango/core/error/exceptions.dart';

abstract class AuthRemoteDataSource {
  /// Stream of [auth.User] which will emit the current user when the
  /// authentication state changes.
  Stream<auth.User?> get user;

  /// Signs in with the given [email] and [password].
  ///
  /// Throws a [ServerException] for all error codes.
  Future<void> signInWithEmail({
    required String email,
    required String password,
  });

  /// Signs up with the given [email] and [password].
  ///
  /// Throws a [ServerException] for all error codes.
  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  });

  /// Signs out the current user.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<void> signOut();
}
