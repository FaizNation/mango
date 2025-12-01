import 'package:mango/core/error/failure.dart';
import 'package:mango/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Stream<UserEntity?> get user;

  /// Throws a [ServerFailure] if a server error occurs.
  Future<void> signInWithEmail({
    required String email,
    required String password,
  });

  /// Throws a [ServerFailure] if a server error occurs.
  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  });

  /// Throws a [ServerFailure] if a server error occurs.
  Future<void> signOut();

  /// Get current authenticated user
  /// Returns null if no user is authenticated
  /// Throws a [ServerFailure] if a server error occurs.
  Future<UserEntity?> getCurrentUser();

  /// Save user session to local storage
  /// Throws a [CacheFailure] if saving fails
  Future<void> saveUserSession(UserEntity user);

  /// Clear user session from local storage
  /// Throws a [CacheFailure] if clearing fails
  Future<void> clearUserSession();
}
