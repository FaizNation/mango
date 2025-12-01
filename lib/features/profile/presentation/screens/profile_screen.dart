import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getwidget/getwidget.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mango/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:mango/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:mango/features/profile/presentation/cubit/profile_state.dart';
import 'package:mango/features/profile/presentation/widgets/profile_info_card.dart';
import 'package:mango/core/presentation/widgets/dialogs/logout_dialog.dart';
import 'package:mango/features/profile/presentation/widgets/edit_photo_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mango/core/utils/image_compressor.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _launchGitHub() async {
    final Uri url = Uri.parse("https://github.com/FaizNation");
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Tidak bisa membuka $url');
    }
  }


  Future<Uint8List?> _pickImage(BuildContext context, ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source);
      if (pickedFile == null) return null;

      final bytes = await pickedFile.readAsBytes();
      return await compressImage(bytes);
    } catch (e) {

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick image: $e')),
        );
      }
      return null;
    }
  }

  Future<void> _handlePhotoEdit(BuildContext context) async {
    final source = await showEditPhotoDialog(context);
    if (source != null) {
      // ignore: use_build_context_synchronously
      final imageBytes = await _pickImage(context, source);
      if (imageBytes != null) {
        // ignore: use_build_context_synchronously
        context.read<ProfileCubit>().updatePhoto(imageBytes);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.unauthenticated) {
          context.go('/login');
        }
      },
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, authState) {
          if (authState.status != AuthStatus.authenticated) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          final user = authState.user!;

          return Scaffold(
            backgroundColor: const Color(0xFFE6F2FF),
            appBar: AppBar(
              title: const Text("Profile"),
              centerTitle: true,
              automaticallyImplyLeading: false,
              backgroundColor: const Color(0xFFE6F2FF),
            ),
            body: BlocListener<ProfileCubit, ProfileState>(
              listener: (context, profileState) {
                 if (profileState.photoUpdateStatus == PhotoUpdateStatus.failure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(profileState.errorMessage ?? 'Failed to update photo')),
                  );
                } else if (profileState.photoUpdateStatus == PhotoUpdateStatus.success) {
                   ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Profile photo updated')),
                  );
                }
              },
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 700),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          BlocBuilder<ProfileCubit, ProfileState>(
                            builder: (context, profileState) {
                              final photoUrl = profileState.newPhotoUrl ?? user.photoUrl;
                               
                              return Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  GFAvatar(
                                    radius: 50,
                                    backgroundColor: Colors.blue[200],
                                    backgroundImage: photoUrl != null && photoUrl.isNotEmpty
                                      ? MemoryImage(base64Decode(photoUrl.split(',').last))
                                      : null,
                                    child: (photoUrl == null || photoUrl.isEmpty)
                                      ? Text(
                                          user.displayName.isNotEmpty ? user.displayName[0].toUpperCase() : "U",
                                          style: const TextStyle(fontSize: 40, color: Colors.white),
                                        )
                                      : null,
                                  ),
                                  Positioned(
                                    right: 0,
                                    bottom: 0,
                                    child: GestureDetector(
                                      onTap: profileState.photoUpdateStatus == PhotoUpdateStatus.loading
                                          ? null
                                          : () => _handlePhotoEdit(context),
                                      child: CircleAvatar(
                                        radius: 16,
                                        backgroundColor: Colors.white,
                                        child: profileState.photoUpdateStatus == PhotoUpdateStatus.loading
                                            ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                                            : Icon(
                                                Icons.edit,
                                                size: 18,
                                                color: Theme.of(context).primaryColor,
                                              ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),

                          const SizedBox(height: 20),
                          Text(
                            user.displayName,
                            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          const SizedBox(height: 8),

                          ProfileInfoCard(
                            icon: Icons.email,
                            title: 'Email',
                            subtitle: user.email,
                            onTap: null,
                          ),
                          const SizedBox(height: 12),
                          ProfileInfoCard(
                            icon: Icons.lock,
                            title: 'Change Password',
                            subtitle: 'Update your password',
                            onTap: () => context.go('/profile/change-password'),
                          ),
                          const SizedBox(height: 12),
                          ProfileInfoCard(
                            icon: Icons.bug_report,
                            title: 'Feedback/bug reports',
                            subtitle: 'Report issues or send feedback',
                            onTap: () => context.go('/profile/feedback'),
                          ),
                          const SizedBox(height: 12),
                          ProfileInfoCard(
                            icon: Icons.info,
                            title: 'About Us',
                            subtitle: 'Learn more about the developer',
                            onTap: () => context.go('/profile/about'),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () async {
                              final confirm = await showLogoutDialog(context);
                              if (confirm == true) {
                                // ignore: use_build_context_synchronously
                                context.read<AuthCubit>().signOut();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(Icons.logout, color: Colors.white),
                                  SizedBox(width: 8),
                                  Text('Logout', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          GestureDetector(
                            onTap: _launchGitHub,
                            child: Text(
                              "Developed by Faiz Nation",
                              style: TextStyle(fontSize: 14, color: Colors.grey[700], decoration: TextDecoration.underline),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
