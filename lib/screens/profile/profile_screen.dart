import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mango/utils/logout_dialog.dart';
import 'package:mango/utils/photo_editor.dart';
import 'package:mango/widgets/profile_info_card.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:mango/cubits/screens/profile/profile_screen_cubit.dart';
import 'package:mango/cubits/screens/profile/profile_screen_state.dart';

class ProfileScreen extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String userPass;

  const ProfileScreen({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.userPass,
  });

  Future<void> _launchGitHub() async {
    final Uri url = Uri.parse("https://github.com/FaizNation");
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Tidak bisa membuka $url');
    }
  }

  Future<void> _showEditPhotoDialog(BuildContext context) async {
    context.read<ProfileCubit>().startDialogLoading();
    try {
      final result = await showPhotoEditor(context);
      if (result != null) {
        // ignore: use_build_context_synchronously
        context.read<ProfileCubit>().setPhotoUrl(result);

        ScaffoldMessenger.of(
          // ignore: use_build_context_synchronously
          context,
        ).showSnackBar(const SnackBar(content: Text('Profile photo updated')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to update photo: $e')));
    } finally {
      // ignore: use_build_context_synchronously
      context.read<ProfileCubit>().stopDialogLoading();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit()..loadCurrentPhoto(),
      child: Scaffold(
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
                    BlocBuilder<ProfileCubit, ProfileState>(
                      buildWhen: (prev, current) =>
                          prev.status != current.status ||
                          prev.photoUrl != current.photoUrl ||
                          prev.isDialogLoading != current.isDialogLoading,
                      builder: (context, state) {
                        String? photoUrl = state.photoUrl;
                        Widget? child;

                        if (state.status == ProfileStatus.loading ||
                            state.status == ProfileStatus.initial) {
                          child = const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          );
                        } else if (photoUrl == null || photoUrl.isEmpty) {
                          child = Text(
                            userName.isNotEmpty
                                ? userName[0].toUpperCase()
                                : "U",
                            style: const TextStyle(
                              fontSize: 40,
                              color: Colors.white,
                            ),
                          );
                        }

                        return Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            GFAvatar(
                              radius: 50,
                              backgroundColor: Colors.blue[200],
                              backgroundImage:
                                  photoUrl != null && photoUrl.isNotEmpty
                                  ? (photoUrl.startsWith('data:')
                                        ? MemoryImage(
                                                base64Decode(
                                                  photoUrl.split(',').last,
                                                ),
                                              )
                                              as ImageProvider
                                        : NetworkImage(photoUrl))
                                  : null,
                              child: child,
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: GestureDetector(
                                onTap: state.isDialogLoading
                                    ? null
                                    : () => _showEditPhotoDialog(context),
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
                        );
                      },
                    ),

                    const SizedBox(height: 20),
                    Text(
                      userName,
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
                      subtitle: userEmail,
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

                    Builder(
                      builder: (context) {
                        return ElevatedButton(
                          onPressed: () async {
                            final confirm = await showLogoutDialog(context);

                            if (confirm == true) {
                              // ignore: use_build_context_synchronously
                              context.go('/login');
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
                        );
                      },
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
      ),
    );
  }
}
