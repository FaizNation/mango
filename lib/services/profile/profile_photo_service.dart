import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:mango/utils/image_compressor.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfilePhotoService {
  final ImagePicker _picker = ImagePicker();

  Future<String?> pickUploadAndSave(ImageSource source) async {
    if (!kIsWeb) {
      PermissionStatus status;
      if (source == ImageSource.gallery) {
        status = await Permission.photos.status;
        if (!status.isGranted) {
          status = await Permission.photos.request();
        }
      } else {
        status = await Permission.camera.status;
        if (!status.isGranted) {
          status = await Permission.camera.request();
        }
      }

      if (!status.isGranted) {
        if (status.isPermanentlyDenied) {
          openAppSettings();
        }
        throw Exception('Permission not granted');
      }
    }

    final picked = await _picker.pickImage(source: source);
    if (picked == null) return null;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('Not signed in');

    final fileBytes = await picked.readAsBytes();
    final compressedBytes = await compressImage(fileBytes);
    final mimeType =
        lookupMimeType(picked.path, headerBytes: compressedBytes) ?? 'image/jpeg';
    final dataUri = 'data:$mimeType;base64,${base64Encode(compressedBytes)}';
    await _persist(user.uid, dataUri);
    return dataUri;
  }

  Future<void> _persist(String uid, String? url) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('Not signed in');

    if (url == null) {
      // This part is for removing a photo, keep it as is.
      try {
        await user.updatePhotoURL(null);
      } catch (_) {}
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'photoUrl': FieldValue.delete(),
      }, SetOptions(merge: true));
      return;
    }

    // Since we are only using data URIs, we only need this part of the logic.
    // The `updatePhotoURL` on the user object does not support data URIs.
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'photoUrl': url,
    }, SetOptions(merge: true));
  }
}
