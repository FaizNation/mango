import 'package:flutter/material.dart';
import 'dart:async';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mango/core/usecase/usecase.dart';
import 'package:mango/features/auth/domain/usecases/get_current_user.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    // Wait for splash screen animation
    await Future.delayed(const Duration(seconds: 4));

    if (!mounted) return;

    try {
      // Check if user is authenticated via Firebase Auth
      final getCurrentUser = GetIt.instance<GetCurrentUser>();
      final user = await getCurrentUser(NoParams());

      if (user != null) {
        // User is logged in, navigate to home
        if (!mounted) return;
        context.go('/home');
      } else {
        // No user logged in, navigate to get started
        if (!mounted) return;
        context.go('/getstarted');
      }
    } catch (e) {
      // On error, navigate to get started
      if (!mounted) return;
      context.go('/getstarted');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/iconSplash.gif', height: 250),
                const SizedBox(height: 30),
                const Text(
                  'WELCOME!',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Anja',
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
