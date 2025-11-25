import 'dart:typed_data';

import 'package:mango/core/error/failure.dart';

abstract class ProfileRepository {
  /// Updates the user's profile photo and returns the new photo URL.
  ///
  /// The [imageBytes] are the raw bytes of the image to upload.
  /// Throws a [ServerFailure] if a server error occurs.
  Future<String> updateProfilePhoto(Uint8List imageBytes);

  /// Changes the user's password.
  ///
  /// Throws a [ServerFailure] if a server error occurs.
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}
