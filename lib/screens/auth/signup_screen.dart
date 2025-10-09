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
                // TextField(
                //   obscureText: _obscurePassword,
                //   decoration: InputDecoration(
                //     prefixIcon: const Icon(Icons.lock_outline),
                //     labelText: 'Confrim password',
                //     errorText: passError,
                //     border: const OutlineInputBorder(
                //       borderRadius: BorderRadius.all(Radius.circular(12)),
                //     ),
                //     suffixIcon: IconButton(
                //       icon: Icon(
                //         _obscurePassword
                //             ? Icons.visibility_off
                //             : Icons.visibility,
                //       ),
                //       onPressed: () {
                //         setState(() {
                //           _obscurePassword = !_obscurePassword;
                //         });
                //       },
                //     ),
                //   ),
                // ),
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
