import 'dart:typed_data';

abstract class ProfileRemoteDataSource {
  /// Updates the user's profile photo and returns the new photo URL.
  Future<String> updateProfilePhoto(Uint8List imageBytes);

  /// Changes the user's password.
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}
