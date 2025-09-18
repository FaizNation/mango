

import 'package:flutter/material.dart';
import 'package:mango/screens/home/home_screen.dart';

// import 'package:flutter_signin_button/flutter_signin_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _obscurePassword = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  String? emailError;
  String? passError;

  void login() {
    setState(() {
      emailError = null;
      passError = null;
    });

    String email = emailController.text.trim();
    String pass = passController.text.trim();

    if (email.isEmpty) {
      setState(() {
        emailError = "Email wajib diisi";
      });
    }

    if (pass.isEmpty) {
      setState(() {
        passError = "Password wajib diisi";
      });
    }

    if (email.isNotEmpty && pass.isNotEmpty) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => MyHomePage(userEmail: email, userPass: pass),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
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
                TextField(
                  controller: emailController,
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
                  controller: passController,
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
                TextField(
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_outline),
                    labelText: 'Confrim password',
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
                        Navigator.pushNamed(context, '/login');
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
    );
  }
}
