import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
// upload logic moved to ProfilePhotoService
import '../../services/profile_photo_service.dart';
import '../../utils/logout_dialog.dart';
import '../../utils/edit_photo_dialog.dart';

class ProfileScreen extends StatefulWidget {
  final String userEmail;
  final String userPass;

  const ProfileScreen({
    super.key,
    required this.userEmail,
    required this.userPass,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _photoUrl;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentPhoto();
  }

  Future<void> _loadCurrentPhoto() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    // prefer Firestore stored profile photo if available
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      final data = doc.data();
      final photo = data != null ? data['photoUrl'] as String? : null;
      setState(() => _photoUrl = photo ?? user.photoURL);
    } catch (_) {
      setState(() => _photoUrl = user.photoURL);
    }
  }

  // logout dialog moved to utils/logout_dialog.dart

  Future<void> _launchGitHub() async {
    final Uri url = Uri.parse("https://github.com/FaizNation");
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Tidak bisa membuka $url');
    }
  }

  Future<void> _showEditPhotoDialog() async {
    final choice = await showEditPhotoDialog(context);
    if (choice == null) return;
    // use service to pick/upload and persist
    if (mounted) setState(() => _loading = true);
    try {
      final service = ProfilePhotoService();
      final result = await service.pickUploadAndSave(choice);
      if (result != null) {
        if (mounted) setState(() => _photoUrl = result);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile photo updated')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to update photo: $e')));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
  // upload logic moved to ProfilePhotoService

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        backgroundColor: const Color(0xFFE6F2FF),
        appBar: AppBar(
          title: const Text("Profile"),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.blue[200],
                    backgroundImage: _photoUrl != null && _photoUrl!.isNotEmpty
                        ? (_photoUrl!.startsWith('data:')
                              ? MemoryImage(
                                      base64Decode(_photoUrl!.split(',').last),
                                    )
                                    as ImageProvider
                              : NetworkImage(_photoUrl!))
                        : null,
                    child: _photoUrl == null || _photoUrl!.isEmpty
                        ? Text(
                            widget.userEmail.isNotEmpty
                                ? widget.userEmail[0].toUpperCase()
                                : "U",
                            style: const TextStyle(
                              fontSize: 40,
                              color: Colors.white,
                            ),
                          )
                        : null,
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: GestureDetector(
                      onTap: _loading ? null : _showEditPhotoDialog,
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.edit,
                          size: 18,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                widget.userEmail,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.email, color: Colors.blue),
                  title: const Text("Email"),
                  subtitle: Text(widget.userEmail),
                ),
              ),
              Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.lock, color: Colors.blue),
                  title: const Text("Password"),
                  subtitle: Text(widget.userPass.replaceAll(RegExp(r'.'), '*')),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () async {
                  final confirm = await showLogoutDialog(context);
                  if (!mounted) return;
                  if (confirm != null && confirm) {
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  }
                },
                icon: const Icon(Icons.logout),
                label: const Text("Logout"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 255, 0, 0),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: _launchGitHub,
                child: Text(
                  "Developed by Faiz Nation",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
