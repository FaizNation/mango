import 'package:mango/services/auth/auth_services.dart';
import 'package:mango/utils/showexit.dart';
import 'package:mango/cubits/auth/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(auth: AuthService()),
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;
          final confirm = await showExitConfirmationDialog(context);
          if (!mounted) return;
          if (confirm) {
            // ignore: use_build_context_synchronously
            Navigator.of(context).pop();
          }
        },
        child: BlocListener<LoginCubit, LoginState>(
          listenWhen: (previous, current) =>
              previous.successData != current.successData ||
              previous.errorMessage != current.errorMessage,
          listener: (context, state) {
            if (state.successData != null) {
              final data = state.successData!;
              context.go('/home', extra: data);
            } else if (state.errorMessage != null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
            }
          },
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () async {
                  final confirm = await showExitConfirmationDialog(context);
                  if (!mounted) return;
                  // ignore: use_build_context_synchronously
                  if (confirm) Navigator.of(context).pop();
                },
              ),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(4.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/logoMango.png', height: 120),
                      SizedBox(height: 5.h),
                      Text(
                        'Welcome Back👋!',
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Ready to continue your adventure?',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Color.fromARGB(255, 9, 9, 9),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 3.h),
                      BlocBuilder<LoginCubit, LoginState>(
                        builder: (context, state) {
                          return TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(2.w),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Email is required';
                              }
                              return null;
                            },
                          );
                        },
                      ),
                      SizedBox(height: 2.h),
                      BlocBuilder<LoginCubit, LoginState>(
                        builder: (context, state) {
                          return TextFormField(
                            controller: passController,
                            obscureText: state.obscurePassword,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(2.w),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  state.obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () {
                                  context
                                      .read<LoginCubit>()
                                      .togglePasswordVisibility();
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password is required';
                              }
                              return null;
                            },
                          );
                        },
                      ),
                      SizedBox(height: 4.h),
                      BlocBuilder<LoginCubit, LoginState>(
                        builder: (context, state) {
                          return ElevatedButton(
                            onPressed: state.isLoading
                                ? null
                                : () {
                                    if (_formKey.currentState!.validate()) {
                                      context.read<LoginCubit>().submit(
                                            emailController.text,
                                            passController.text,
                                          );
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 3.h),
                              backgroundColor: const Color(0xFF2563EB),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2.w),
                              ),
                            ),
                            child: state.isLoading
                                ? const SizedBox(
                                    height: 16,
                                    width: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    "LogIn",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                          );
                        },
                      ),
                      SizedBox(height: 300),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Haven’t any account? "),
                          GestureDetector(
                            onTap: () {
                              context.go('/signup');
                            },
                            child: const Text(
                              "Sign up",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}