import 'package:mango/cubits/auth/signup_cubit.dart';
import 'package:mango/services/auth/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/logoMango.png', height: 120),
                    const SizedBox(height: 35),
                    const Text(
                      'Hajimemashite😺!',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Text(
                      "Let's start your new journey at Mango!",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 50),
                    BlocBuilder<SignupCubit, SignupState>(
                      builder: (context, state) {
                        return TextField(
                          controller: _userController,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.person_2_outlined),
                            labelText: 'User',
                            errorText: state.userError,
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    BlocBuilder<SignupCubit, SignupState>(
                      builder: (context, state) {
                        return TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.email_outlined),
                            labelText: 'Email',
                            errorText: state.emailError,
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    BlocBuilder<SignupCubit, SignupState>(
                      builder: (context, state) {
                        return TextField(
                          controller: _passController,
                          obscureText: state.obscurePassword,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock_outline),
                            labelText: 'Password',
                            errorText: state.passError,
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
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
                    const SizedBox(height: 20),
                    BlocBuilder<SignupCubit, SignupState>(
                      builder: (context, state) {
                        return ElevatedButton(
                          onPressed: state.isLoading
                              ? null
                              : () => context.read<SignupCubit>().submit(
                                  _userController.text,
                                  _emailController.text,
                                  _passController.text,
                                ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: const Color(0xFF2563EB),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
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
                              : const Text(
                                  "Create Account",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                        );
                      },
                    ),
                    const SizedBox(height: 250),
                    // Row(
                    //   children: const [
                    //     Expanded(child: Divider()),
                    //     Padding(
                    //       padding: EdgeInsets.symmetric(horizontal: 10),
                    //       child: Text("Atau daftar dengan"),
                    //     ),
                    //     Expanded(child: Divider()),
                    //   ],
                    // ),
                    // const SizedBox(height: 20),
                    // SizedBox(
                    //   width: 200,
                    //   height: 50,
                    //   child: SignInButton(
                    //     Buttons.Google,
                    //     onPressed: () {},
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(12),
                    //     ),
                    //   ),
                    // ),
                    // const SizedBox(height: 16),

                    // SizedBox(
                    //   width: 220,
                    //   height: 50,
                    //   child: SignInButton(
                    //     Buttons.Facebook,
                    //     onPressed: () {},
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(12),
                    //     ),
                    //   ),
                    // ),
                    // const SizedBox(height: 16),

                    // SizedBox(
                    //   width: 220,
                    //   height: 50,
                    //   child: SignInButton(
                    //     Buttons.GitHub,
                    //     onPressed: () {},
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(12),
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account? "),
                        GestureDetector(
                          onTap: () {
                            context.go('/login');
                          },
                          child: const Text(
                            " Sign in",
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
    );
  }
}
