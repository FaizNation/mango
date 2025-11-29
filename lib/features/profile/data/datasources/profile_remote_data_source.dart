import 'dart:typed_data';

abstract class ProfileRemoteDataSource {
  Future<String> updateProfilePhoto(Uint8List imageBytes);

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}
