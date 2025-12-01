import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  /// Request camera permission. Returns true if granted or running on web.
  Future<bool> requestCameraPermission() async {
    if (kIsWeb) return true;
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  /// Request gallery/media permission. Handles platform differences.
  Future<bool> requestGalleryPermission() async {
    if (kIsWeb) return true;

    if (Platform.isIOS || Platform.isMacOS) {
      final status = await Permission.photos.request();
      return status.isGranted;
    }

    if (Platform.isAndroid) {
      // On Android, try requesting the most relevant permissions.
      // Requesting multiple entries is safe; unsupported ones are ignored on the platform.
      final statuses = await [
        Permission.photos,
        Permission.storage,
        Permission.accessMediaLocation,
      ].request();
      return statuses.values.any((s) => s.isGranted);
    }

    // Fallback: request storage permission
    final status = await Permission.storage.request();
    return status.isGranted;
  }
}
