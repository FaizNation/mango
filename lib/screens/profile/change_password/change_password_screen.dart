import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Impor ini boleh ada/tidak
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mango/cubits/screens/profile/change/change_password_screen_cubit.dart';
import 'package:mango/cubits/screens/profile/change/change_password_screen_state.dart';

class ChangePasswordScreen extends StatefulWidget {
  // FIX 1: Menggunakan super.key untuk konstruktor modern
  const ChangePasswordScreen({super.key});

  @override
  // FIX 2: Menggunakan State<ChangePasswordScreen>
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    // FIX 3: Pastikan untuk memanggil dispose() pada controller
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;
    context.read<ChangePasswordCubit>().updatePassword(
          _currentController.text,
          _newController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChangePasswordCubit(),
      child: Scaffold(
        // Menambahkan AppBar kembali agar lengkap
        appBar: AppBar(
          title: const Text('Change Password'),
          backgroundColor: const Color(0xFFE6F2FF),
        ),
        body: BlocListener<ChangePasswordCubit, ChangePasswordState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            if (state.status == ChangePasswordStatus.success) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Password updated successfully')),
              );
              Navigator.of(context).pop();
            }
            if (state.status == ChangePasswordStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${state.error ?? 'Unknown error'}')),
              );
            }
          },
          child: BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
            // buildWhen ini sudah benar, hanya rebuild saat visibility berubah
            buildWhen: (previous, current) => previous.isObscure != current.isObscure,
            builder: (context, state) {
              return Center(
                child: Container(
                  // Menambahkan constraints kembali
                  constraints: const BoxConstraints(maxWidth: 700),
                  child: SingleChildScrollView(
                    child: Padding(
                      // Mengganti padding ke EdgeInsets.all agar konsisten
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // --- Current Password ---
                            TextFormField(
                              controller: _currentController,
                              obscureText: state.isObscure,
                              decoration: InputDecoration(
                                labelText: 'Current password',
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    state.isObscure
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () {
                                    context.read<ChangePasswordCubit>().togglePasswordVisibility();
                                  },
                                ),
                              ),
                              // FIX 4: Menambahkan validator yang hilang
                              validator: (v) => (v == null || v.isEmpty)
                                  ? 'Enter current password'
                                  : null,
                            ),

                            // FIX 5: Menambahkan SizedBox
                            const SizedBox(height: 12),

                            // --- New Password ---
                            TextFormField(
                              controller: _newController,
                              obscureText: state.isObscure,
                              decoration: InputDecoration(
                                labelText: 'New password',
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    state.isObscure
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () {
                                    context.read<ChangePasswordCubit>().togglePasswordVisibility();
                                  },
                                ),
                              ),
                              // FIX 6: Validator yang benar untuk New Password
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return 'Please enter a new password';
                                }
                                if (v.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ), // <-- FIX 7: TextFormField New Password selesai di sini

                            // FIX 5: Menambahkan SizedBox
                            const SizedBox(height: 12),

                            // --- Confirm Password ---
                            // FIX 8: Memindahkan TextFormField Confirm Password ke LUAR
                            TextFormField(
                              controller: _confirmController,
                              obscureText: state.isObscure,
                              decoration: InputDecoration(
                                labelText: 'Confirm new password',
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    state.isObscure
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () {
                                    context.read<ChangePasswordCubit>().togglePasswordVisibility();
                                  },
                                ),
                              ),
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return 'Please confirm your new password';
                                }
                                if (v != _newController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),

                            // FIX 5: Menambahkan SizedBox
                            const SizedBox(height: 24),

                            // --- Tombol ---
                            BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
                              // buildWhen ini sudah benar, hanya rebuild saat status loading berubah
                              buildWhen: (previous, current) => previous.status != current.status,
                              builder: (context, state) {
                                final isLoading = state.status == ChangePasswordStatus.loading;
                                return ElevatedButton(
                                  onPressed: isLoading ? null : _submitForm,
                                  child: isLoading
                                      ? const CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                        )
                                      : const Text('Update Password'),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}