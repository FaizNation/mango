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
}
