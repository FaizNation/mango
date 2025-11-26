import 'package:mango/features/auth/domain/repositories/auth_repository.dart';
import 'package:mango/features/auth/domain/usecases/sign_in_with_email.dart';
import 'package:mango/features/auth/presentation/cubit/login_cubit.dart';
import 'package:mango/core/presentation/widgets/dialogs/exit_dialog.dart';
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
      create: (context) => LoginCubit(
        signInWithEmail: SignInWithEmail(
          context.read<AuthRepository>(),
        ),
      ),
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;
          final confirm = await showExitConfirmationDialog(context);
          if (!mounted) return;
          if (confirm) {
            context.go('/getstarted');
          }
        },
        child: BlocListener<LoginCubit, LoginState>(
          listenWhen: (previous, current) =>
              previous.isSuccess != current.isSuccess && current.isSuccess,
          listener: (context, state) {
            if (state.isSuccess) {
              context.go('/home');
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
                  if (confirm) context.go('/getstarted');
                },
              ),
            ),
            body: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isDesktop = constraints.maxWidth > 600;
                  return Center(
                    child: SingleChildScrollView(
                      child: Container(
                        constraints:
                            BoxConstraints(maxWidth: isDesktop ? 50.w : 90.w),
                        padding: EdgeInsets.all(isDesktop ? 20 : 4.w),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/images/logoMango.png',
                                  height: isDesktop ? 100 : 15.h),
                              SizedBox(height: isDesktop ? 20 : 5.h),
                              Text(
                                'Welcome Back👋!',
                                style: TextStyle(
                                  fontSize: isDesktop ? 24 : 24.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: isDesktop ? 10 : 2.h),
                              Text(
                                'Ready to continue your adventure?',
                                style: TextStyle(
                                  fontSize: isDesktop ? 16 : 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: const Color.fromARGB(255, 9, 9, 9),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: isDesktop ? 20 : 3.h),
                              BlocBuilder<LoginCubit, LoginState>(
                                builder: (context, state) {
                                  return TextFormField(
                                    controller: emailController,
                                    decoration: InputDecoration(
                                      labelText: 'Email',
                                      errorText: state.emailError,
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8),
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
                              SizedBox(height: isDesktop ? 20 : 2.h),
                              BlocBuilder<LoginCubit, LoginState>(
                                builder: (context, state) {
                                  return TextFormField(
                                    controller: passController,
                                    obscureText: state.obscurePassword,
                                    decoration: InputDecoration(
                                      labelText: 'Password',
                                      errorText: state.passError,
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8),
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
                              SizedBox(height: isDesktop ? 30 : 4.h),
                              BlocBuilder<LoginCubit, LoginState>(
                                builder: (context, state) {
                                  return ElevatedButton(
                                    onPressed: state.isLoading
                                        ? null
                                        : () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              context.read<LoginCubit>().submit(
                                                    emailController.text,
                                                    passController.text,
                                                  );
                                            }
                                          },
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                          vertical: isDesktop ? 20 : 2.5.h),
                                      backgroundColor:
                                          const Color(0xFF2563EB),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8),
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
                                              fontSize: isDesktop ? 16 : 16.sp,
                                            ),
                                          ),
                                  );
                                },
                              ),
                              SizedBox(height: isDesktop ? 100 : 30.h),
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
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
