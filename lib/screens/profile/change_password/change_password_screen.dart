import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mango/cubits/screens/profile/change/change_password_screen_cubit.dart';
import 'package:mango/cubits/screens/profile/change/change_password_screen_state.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
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
                SnackBar(
                  content: Text('Error: ${state.error ?? 'Unknown error'}'),
                ),
              );
            }
          },
          child: BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
            buildWhen: (previous, current) =>
                previous.isObscure != current.isObscure,
            builder: (context, state) {
              return Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 700),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
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
                                    context
                                        .read<ChangePasswordCubit>()
                                        .togglePasswordVisibility();
                                  },
                                ),
                              ),

                              validator: (v) => (v == null || v.isEmpty)
                                  ? 'Enter current password'
                                  : null,
                            ),

                            const SizedBox(height: 12),

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
                                    context
                                        .read<ChangePasswordCubit>()
                                        .togglePasswordVisibility();
                                  },
                                ),
                              ),

                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return 'Please enter a new password';
                                }
                                if (v.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 12),

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
                                    context
                                        .read<ChangePasswordCubit>()
                                        .togglePasswordVisibility();
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

                            const SizedBox(height: 24),

                            BlocBuilder<
                              ChangePasswordCubit,
                              ChangePasswordState
                            >(
                              buildWhen: (previous, current) =>
                                  previous.status != current.status,
                              builder: (context, state) {
                                final isLoading =
                                    state.status ==
                                    ChangePasswordStatus.loading;
                                return ElevatedButton(
                                  onPressed: isLoading ? null : _submitForm,
                                  child: isLoading
                                      ? const CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
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
