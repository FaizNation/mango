import 'package:mango/cubits/auth/signup_cubit.dart';
import 'package:mango/services/auth/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

// import 'package:flutter_signin_button/flutter_signin_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  @override
  void dispose() {
    _userController.dispose();
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignupCubit(auth: AuthService()),
      child: BlocListener<SignupCubit, SignupState>(
        listenWhen: (p, c) =>
            p.successData != c.successData || p.errorMessage != c.errorMessage,
        listener: (context, state) {
          if (state.successData != null) {
            final data = state.successData!;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Registration successful')),
            );
            context.go('/home', extra: data);
          } else if (state.errorMessage != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          }
        },
        child: Scaffold(
          appBar: AppBar(backgroundColor: Colors.white),
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth > 600;
                return Center(
                  child: SingleChildScrollView(
                    child: Container(
                      constraints:
                          BoxConstraints(maxWidth: isDesktop ? 50.w : 90.w),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: isDesktop ? 20 : 8.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/images/logoMango.png',
                                height: isDesktop ? 100 : 20.h),
                            SizedBox(height: isDesktop ? 20 : 5.h),
                            Text(
                              'Hajimemashite😺!',
                              style: TextStyle(
                                fontSize: isDesktop ? 24 : 24.sp,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "Let's start your new journey at Mango!",
                              style: TextStyle(
                                fontSize: isDesktop ? 16 : 14.sp,
                                fontWeight: FontWeight.w400,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: isDesktop ? 30 : 8.h),
                            BlocBuilder<SignupCubit, SignupState>(
                              builder: (context, state) {
                                return TextField(
                                  controller: _userController,
                                  decoration: InputDecoration(
                                    prefixIcon:
                                        const Icon(Icons.person_2_outlined),
                                    labelText: 'User',
                                    errorText: state.userError,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: isDesktop ? 20 : 2.h),
                            BlocBuilder<SignupCubit, SignupState>(
                              builder: (context, state) {
                                return TextField(
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                    prefixIcon:
                                        const Icon(Icons.email_outlined),
                                    labelText: 'Email',
                                    errorText: state.emailError,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: isDesktop ? 20 : 2.h),
                            BlocBuilder<SignupCubit, SignupState>(
                              builder: (context, state) {
                                return TextField(
                                  controller: _passController,
                                  obscureText: state.obscurePassword,
                                  decoration: InputDecoration(
                                    prefixIcon:
                                        const Icon(Icons.lock_outline),
                                    labelText: 'Password',
                                    errorText: state.passError,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        state.obscurePassword
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                      ),
                                      onPressed: () {
                                        context
                                            .read<SignupCubit>()
                                            .togglePasswordVisibility();
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: isDesktop ? 30 : 3.h),
                            BlocBuilder<SignupCubit, SignupState>(
                              builder: (context, state) {
                                return ElevatedButton(
                                  onPressed: state.isLoading
                                      ? null
                                      : () =>
                                          context.read<SignupCubit>().submit(
                                              _userController.text,
                                              _emailController.text,
                                              _passController.text,
                                            ),
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                      vertical: isDesktop ? 20 : 2.5.h,
                                      horizontal: 4.w,
                                    ),
                                    backgroundColor:
                                        const Color(0xFF2563EB),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: state.isLoading
                                      ? SizedBox(
                                          height: 6.w,
                                          width: 6.w,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 1.w,
                                            color: Colors.white,
                                          ),
                                        )
                                      : Text(
                                          "Create Account",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: isDesktop ? 16 : 16.sp,
                                          ),
                                        ),
                                );
                              },
                            ),
                            SizedBox(height: isDesktop ? 100 : 15.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Already have an account? ",
                                  style: TextStyle(
                                      fontSize: isDesktop ? 14 : 14.sp),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    context.go('/login');
                                  },
                                  child: Text(
                                    " Sign in",
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: isDesktop ? 14 : 14.sp,
                                    ),
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
    );
  }
}
