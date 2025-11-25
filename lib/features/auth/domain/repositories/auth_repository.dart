import 'package:mango/core/error/failure.dart';
import 'package:mango/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  /// Stream of [UserEntity] which will emit the current user when the
  /// authentication state changes.
  Stream<UserEntity?> get user;

  /// Signs in with the given [email] and [password].
  ///
  /// Throws a [ServerFailure] if a server error occurs.
  Future<void> signInWithEmail({
    required String email,
    required String password,
  });

  /// Signs up with the given [email] and [password].
  ///
  /// Throws a [ServerFailure] if a server error occurs.
  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  });

  /// Signs out the current user.
  ///
  /// Throws a [ServerFailure] if a server error occurs.
  Future<void> signOut();
}
