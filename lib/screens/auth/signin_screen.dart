import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mango/services/auth/auth_services.dart';
import 'package:mango/utils/showexit.dart';
import 'package:mango/widgets/main_navigation_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  String? emailError;
  String? passError;

  Future<void> login() async {
    setState(() {
      emailError = null;
      passError = null;
    });

    final email = emailController.text.trim();
    final pass = passController.text.trim();

    if (email.isEmpty) {
      setState(() => emailError = 'Yo! Don’t forget your email');
    }
    if (pass.isEmpty) {
      setState(() => passError = 'No password, no entry');
    }
    if (email.isEmpty || pass.isEmpty) return;

    final auth = AuthService();
    try {
      final cred = await auth.signInWithEmail(email, pass);
      final user = cred.user;

      String userName = '';
      if (user != null) {
        userName = user.displayName ?? '';
        if (userName.isEmpty) {
          try {
            final doc = await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get();
            if (doc.exists) {
              final data = doc.data();
              if (data != null && data['displayName'] != null) {
                userName = data['displayName'] as String;
              }
            }
          } catch (fireErr) {
            // ignore firestore read error — we'll fallback to email
          }
        }
      }

      if (userName.isEmpty) userName = email;

      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => MainNavigationScreen(
            userName: userName,
            userEmail: email,
            userPass: pass,
          ),
        ),
      );
    } catch (err) {
      final message = err is Exception
          ? err.toString().replaceAll('Exception: ', '')
          : 'Login failed';
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
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
      child: Scaffold(
        backgroundColor: const Color(0xFFE6F2FF),
        appBar: AppBar(
          backgroundColor: const Color(0xFFE6F2FF),
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
        body: LayoutBuilder(
          builder: (context, constraints) {
            final bool isDesktop = constraints.maxWidth > 600;

            return SafeArea(
              child: Center(
                child: SizedBox(
                  width: isDesktop ? 450 : null,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    // FIX: Wrapped the Column in a SingleChildScrollView
                    // This prevents the overflow error when the keyboard appears.
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Added top padding to give some space when scrolling
                          const SizedBox(height: 20),
                          Image.asset('assets/images/logoMango.png',
                              height: 120),
                          const SizedBox(height: 35),
                          const Text(
                            'Welcome👋!',
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const Text(
                            'Ready to continue your adventure?',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: Color.fromARGB(255, 9, 9, 9),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 50),
                          TextField(
                            controller: emailController,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.email_outlined),
                              labelText: 'Email',
                              errorText: emailError,
                              border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: passController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.lock_outline),
                              labelText: 'Password',
                              errorText: passError,
                              border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
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
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {},
                              child: const Text("forgot password?"),
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: login,
                            style: ElevatedButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: const Color(0xFF2563EB),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              "LogIn",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18),
                            ),
                          ),
                          // FIX: Replaced Spacer with a SizedBox.
                          // A Spacer cannot be used in a scrollable view,
                          // so this provides fixed spacing instead.
                          const SizedBox(height: 150),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Haven’t any account? "),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, '/signin');
                                },
                                child: const Text(
                                  "Sign up",
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                            ],
                          ),
                          // Add some final padding at the bottom
                          const SizedBox(height: 40),
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
    );
  }
}
