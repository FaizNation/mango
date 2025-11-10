import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<ImageSource?> showEditPhotoDialog(BuildContext context) {
  return showDialog<ImageSource?>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Edit Profile Photo'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton.icon(
            onPressed: () => Navigator.of(ctx).pop(ImageSource.gallery),
            icon: const Icon(Icons.photo_library),
            label: const Text('Choose from gallery'),
          ),
          const SizedBox(height: 8),
          // ElevatedButton.icon(
          //   onPressed: () => Navigator.of(ctx).pop(ImageSource.camera),
          //   icon: const Icon(Icons.camera_alt),
          //   label: const Text('Take photo'),
          // ),
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
