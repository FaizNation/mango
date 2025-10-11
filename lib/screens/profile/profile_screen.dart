import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:mango/utils/logout_dialog.dart';
import 'package:mango/utils/photo_editor.dart';
import 'package:mango/widgets/profile_info_card.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'change_password/change_password_screen.dart';
import 'feedback/feedback_screen.dart';
import 'about/about_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String userName;
  final String userEmail;
  final String userPass;

  const ProfileScreen({
    super.key,
    required this.userName,
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

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      final data = doc.data();
      final photo = data != null ? data['photoUrl'] as String? : null;
      if (mounted) {
        setState(() => _photoUrl = photo ?? user.photoURL);
      }
    } catch (_) {
      if (mounted) {
        setState(() => _photoUrl = user.photoURL);
      }
    }
  }

  Future<void> _launchGitHub() async {
    final Uri url = Uri.parse("https://github.com/FaizNation");
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Tidak bisa membuka $url');
    }
  }

  Future<void> _showEditPhotoDialog() async {
    if (mounted) setState(() => _loading = true);
    try {
      final result = await showPhotoEditor(context);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F2FF),
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFE6F2FF),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      GFAvatar(
                        radius: 50,
                        backgroundColor: Colors.blue[200],
                        backgroundImage:
                            _photoUrl != null && _photoUrl!.isNotEmpty
                            ? (_photoUrl!.startsWith('data:')
                                  ? MemoryImage(
                                          base64Decode(
                                            _photoUrl!.split(',').last,
                                          ),
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
                    widget.userName,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),

                  const SizedBox(height: 8),
                  ProfileInfoCard(
                    icon: Icons.email,
                    title: 'Email',
                    subtitle: widget.userEmail,
                    onTap: null,
                  ),
                  const SizedBox(height: 12),
                  ProfileInfoCard(
                    icon: Icons.lock,
                    title: 'Change Password',
                    subtitle: 'Update your password',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ChangePasswordScreen(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ProfileInfoCard(
                    icon: Icons.bug_report,
                    title: 'Feedback/bug reports',
                    subtitle: 'Report issues or send feedback',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const FeedbackScreen()),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ProfileInfoCard(
                    icon: Icons.info,
                    title: 'About Us',
                    subtitle: 'Learn more about the developer',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const AboutScreen()),
                    ),
                  ),

                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () async {
                      final confirm = await showLogoutDialog(context);
                      if (!mounted) return;
                      if (confirm != null && confirm) {
                        // ignore: use_build_context_synchronously
                        Navigator.of(
                          // ignore: use_build_context_synchronously
                          context,
                        ).popUntil((route) => route.isFirst);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 12.0,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.logout, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'Logout',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
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
        ),
      ),
    );
  }
}
