import 'package:flutter/material.dart';
// import '../services/profile/profile_photo_service.dart';
import 'edit_photo_dialog.dart';

Future<String?> showPhotoEditor(BuildContext context) async {
  final choice = await showEditPhotoDialog(context);
  if (choice == null) return null;
  return null;
}
