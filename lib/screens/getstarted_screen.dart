import 'package:flutter/material.dart';

class GetStartedPage extends StatelessWidget {
  const GetStartedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F2FF),

      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isDesktop = constraints.maxWidth > 600;

          return Stack(
            children: [
              Positioned(
                top: isDesktop ? -950 : -1200,
                left: isDesktop ? -150 : -200,
                right: isDesktop ? -150 : -200,
                child: Container(
                  height: isDesktop ? 1200 : 2000,
                  decoration: const BoxDecoration(
                    color: Color(0xFF007BFF),
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      const SizedBox(height: 80),
                      const Center(
                        child: CircleAvatar(
                          radius: 40,
                          backgroundImage: AssetImage("assets/images/icon.png"),
                        ),
                      ),
                      const SizedBox(height: 100),

                      Align(
                        alignment: isDesktop
                            ? Alignment.center
                            : Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: isDesktop
                              ? CrossAxisAlignment.center
                              : CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Let’s Begin",
                              style: TextStyle(
                                fontSize: 60,
                                fontWeight: FontWeight.w900,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              "the Story",
                              style: TextStyle(
                                fontSize: 60,
                                fontWeight: FontWeight.w900,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 50),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, "/signin");
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF007BFF),
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 14,
                          ),
                        ),
                        child: const Text(
                          "Get started",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already have an account? "),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/login');
                            },
                            child: const Text(
                              "Sign in",
                              style: TextStyle(
                                color: Color(0xFF007BFF),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              Positioned(
                bottom: 0,
                left: 0,
                child: Image.asset("assets/images/anime1.png", height: 280),
              ),
            ],
          );
        },
      ),
    );
  }
}
