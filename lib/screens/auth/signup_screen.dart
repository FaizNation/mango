import 'package:flutter/material.dart';
import 'package:mango/services/auth/auth_services.dart';
import 'package:mango/widgets/main_navigation_screen.dart';
// import 'package:flutter_signin_button/flutter_signin_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _obscurePassword = true;
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  String? userError;
  String? emailError;
  String? passError;

  void login() async {
    setState(() {
      userError = null;
      emailError = null;
      passError = null;
    });

    final user = _userController.text.trim();
    final email = _emailController.text.trim();
    final pass = _passController.text.trim();

    var hasError = false;
    if (user.isEmpty) {
      hasError = true;
      setState(() => userError = 'User wajib diisi');
    }
    if (email.isEmpty) {
      hasError = true;
      setState(() => emailError = 'Email wajib diisi');
    }
    if (pass.isEmpty) {
      hasError = true;
      setState(() => passError = 'Password wajib diisi');
    }
    if (hasError) return;

    final auth = AuthService();
    try {
      await auth.signUpWithEmail(email, pass, displayName: user);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Registration successful')));
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => MainNavigationScreen(
            userName: user,
            userEmail: email,
            userPass: pass,
          ),
        ),
      );
    } catch (e) {
      final message = e is Exception
          ? e.toString().replaceAll('Exception: ', '')
          : 'Registration failed';
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white),
      // Use LayoutBuilder to create a responsive layout
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Check if the screen width is wide enough for a desktop layout
          final bool isDesktop = constraints.maxWidth > 600;

          return SafeArea(
            child: Center(
              // Center the content
              child: SizedBox(
                // Constrain the width on desktop for shorter text fields
                width: isDesktop ? 450 : null,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
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
                      TextField(
                        controller: _userController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person_2_outlined),
                          labelText: 'User',
                          errorText: userError,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email_outlined),
                          labelText: 'Email',
                          errorText: emailError,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _passController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock_outline),
                          labelText: 'Password',
                          errorText: passError,
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // ... (Your commented out confirm password field)
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: login,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: const Color(0xFF2563EB),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Create Account",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                      
                      // Use a Spacer to push the content below it to the bottom
                      // This replaces the large SizedBox and prevents scrolling
                      const Spacer(),

                      // ... (Your commented out social sign-in buttons)
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already have an account? "),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/login');
                            },
                            child: const Text(
                              " Sign in",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                      // Add some final padding at the bottom
                      const SizedBox(height: 20),
                    ],
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