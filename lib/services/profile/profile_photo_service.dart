import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

class ProfilePhotoService {
  final ImagePicker _picker = ImagePicker();

  Future<String?> pickUploadAndSave(ImageSource source) async {
    final picked = await _picker.pickImage(
      source: source,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 80,
    );
    if (picked == null) return null;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('Not signed in');

    final fileBytes = await picked.readAsBytes();
    final mimeType = lookupMimeType(picked.path) ?? 'image/jpeg';

    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('user_photos')
          .child('${user.uid}.jpg');
      final uploadTask = ref.putData(
        fileBytes,
        SettableMetadata(contentType: mimeType),
      );
      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();
      await _persist(user.uid, downloadUrl);
      return downloadUrl;
    } on FirebaseException catch (_) {
      // Fallback to storing data URI in Firestore
      final dataUri = 'data:$mimeType;base64,${base64Encode(fileBytes)}';
      await _persist(user.uid, dataUri);
      return dataUri;
    }
  }

  Future<void> _persist(String uid, String? url) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('Not signed in');

    if (url == null) {
      try {
        await user.updatePhotoURL(null);
      } catch (_) {}
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'photoUrl': FieldValue.delete(),
      }, SetOptions(merge: true));
      return;
    }

    if (url.startsWith('data:')) {
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'photoUrl': url,
      }, SetOptions(merge: true));
    } else {
      // Network URL: update both Auth profile and Firestore
      await user.updatePhotoURL(url);
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'photoUrl': url,
      }, SetOptions(merge: true));
    }
  }
}
