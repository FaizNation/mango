import 'package:flutter/material.dart';
import 'dart:async';
import 'package:mango/screens/getstarted_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const GetStartedPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // ambil ukuran layar

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final height = constraints.maxHeight;

              // skala proporsional
              double imageHeight = height * 0.3;
              double welcomeFontSize = width * 0.07; // proporsional terhadap lebar
              double creditFontSize = width * 0.025;

              // batas minimum & maksimum biar tetap nyaman
              if (welcomeFontSize < 24) welcomeFontSize = 24;
              if (welcomeFontSize > 48) welcomeFontSize = 48;

              if (creditFontSize < 12) creditFontSize = 12;
              if (creditFontSize > 20) creditFontSize = 20;

              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: height),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/iconSplash.gif',
                        height: imageHeight,
                      ),
                      SizedBox(height: height * 0.05),
                      Text(
                        'WELCOME!',
                        style: TextStyle(
                          fontSize: welcomeFontSize,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Anja',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: height * 0.3),
                      Text(
                        'Developed by Faiz Nation',
                        style: TextStyle(
                          fontSize: creditFontSize,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
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
