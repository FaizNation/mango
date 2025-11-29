import 'dart:typed_data';

import 'package:mango/core/error/failure.dart';

abstract class ProfileRepository {
  /// Throws a [ServerFailure] if a server error occurs.
  Future<String> updateProfilePhoto(Uint8List imageBytes);

  /// Throws a [ServerFailure] if a server error occurs.
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}
