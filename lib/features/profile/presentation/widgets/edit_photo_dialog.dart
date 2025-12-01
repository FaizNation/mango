import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mango/injection.dart';
import 'package:mango/core/services/permission_service.dart';
import 'package:permission_handler/permission_handler.dart';

Future<ImageSource?> showEditPhotoDialog(BuildContext context) {
  final permissionService = sl<PermissionService>();

  return showDialog<ImageSource?>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Edit Profile Photo'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton.icon(
            onPressed: () async {
              final granted = await permissionService
                  .requestGalleryPermission();
              if (granted) {
                // ignore: use_build_context_synchronously
                Navigator.of(ctx).pop(ImageSource.gallery);
              } else {
                _showPermissionDeniedDialog(
                  // ignore: use_build_context_synchronously
                  ctx,
                  'Gallery access is required to choose a photo.',
                );
              }
            },
            icon: const Icon(Icons.photo_library),
            label: const Text('Choose from gallery'),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () async {
              final granted = await permissionService.requestCameraPermission();
              if (granted) {
                // ignore: use_build_context_synchronously
                Navigator.of(ctx).pop(ImageSource.camera);
              } else {
                _showPermissionDeniedDialog(
                  // ignore: use_build_context_synchronously
                  ctx,
                  'Camera access is required to take a photo.',
                );
              }
            },
            icon: const Icon(Icons.camera_alt),
            label: const Text('Take photo'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(null),
          child: const Text('Cancel'),
        ),
      ],
    ),
  );
}

void _showPermissionDeniedDialog(BuildContext context, String message) {
  showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Permission required'),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(ctx).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            Navigator.of(ctx).pop();
            await openAppSettings();
          },
          child: const Text('Open Settings'),
        ),
      ],
    ),
  );
}
