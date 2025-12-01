import 'package:mango/features/auth/data/models/user_model.dart';

abstract class AuthLocalDataSource {
  /// Save user session to local storage
  /// Throws a [CacheException] if saving fails
  Future<void> saveUserSession(UserModel user);

  /// Get user session from local storage
  /// Returns null if no session exists
  /// Throws a [CacheException] if retrieval fails
  Future<UserModel?> getUserSession();

  /// Clear user session from local storage
  /// Throws a [CacheException] if clearing fails
  Future<void> clearUserSession();

  /// Check if a valid session exists
  Future<bool> hasValidSession();
}
