import 'package:mango/core/error/exceptions.dart';
import 'package:mango/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:mango/features/auth/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  // Keys for storing user data
  static const String _keyUserId = 'user_uid';
  static const String _keyUserEmail = 'user_email';
  static const String _keyUserDisplayName = 'user_display_name';
  static const String _keyUserPhotoUrl = 'user_photo_url';

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> saveUserSession(UserModel user) async {
    try {
      await Future.wait([
        sharedPreferences.setString(_keyUserId, user.uid),
        sharedPreferences.setString(_keyUserEmail, user.email),
        sharedPreferences.setString(_keyUserDisplayName, user.displayName),
        if (user.photoUrl != null)
          sharedPreferences.setString(_keyUserPhotoUrl, user.photoUrl!),
      ]);
    } catch (e) {
      throw CacheException('Failed to save user session: $e');
    }
  }

  @override
  Future<UserModel?> getUserSession() async {
    try {
      final uid = sharedPreferences.getString(_keyUserId);
      final email = sharedPreferences.getString(_keyUserEmail);
      final displayName = sharedPreferences.getString(_keyUserDisplayName);
      final photoUrl = sharedPreferences.getString(_keyUserPhotoUrl);

      if (uid == null || email == null || displayName == null) {
        return null;
      }

      return UserModel(
        uid: uid,
        email: email,
        displayName: displayName,
        photoUrl: photoUrl,
      );
    } catch (e) {
      throw CacheException('Failed to get user session: $e');
    }
  }

  @override
  Future<void> clearUserSession() async {
    try {
      await Future.wait([
        sharedPreferences.remove(_keyUserId),
        sharedPreferences.remove(_keyUserEmail),
        sharedPreferences.remove(_keyUserDisplayName),
        sharedPreferences.remove(_keyUserPhotoUrl),
      ]);
    } catch (e) {
      throw CacheException('Failed to clear user session: $e');
    }
  }

  @override
  Future<bool> hasValidSession() async {
    try {
      final uid = sharedPreferences.getString(_keyUserId);
      final email = sharedPreferences.getString(_keyUserEmail);
      final displayName = sharedPreferences.getString(_keyUserDisplayName);

      return uid != null && email != null && displayName != null;
    } catch (e) {
      return false;
    }
  }
}
