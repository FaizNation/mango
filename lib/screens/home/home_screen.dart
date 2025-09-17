
import 'package:flutter/material.dart';
import 'package:mango/content/comic.dart';
import 'package:mango/content/detail.dart';

class MyHomePage extends StatelessWidget {
  final String userEmail;
  final String userPass;

  final List<String> animeList = [
    "Naruto Shippuden",
    "One Piece",
    "Attack on Titan",
    "Demon Slayer",
    "Jujutsu Kaisen",
    "Fullmetal Alchemist",
    "Tokyo Ghoul",
    "Bleach",
    "Death Note",
    "My Hero Academia",
  ];

  final sampleComics = [
    Comic(
      title: 'One piece',
      subtitle: 'Chapter 1107 • Updated',
      imageUrl: 'assets/images/newcomic/onePiece.png',
    ),
    Comic(
      title: 'Boku no Hero',
      subtitle: 'chapter 430 • Completed',
      imageUrl: 'assets/images/newcomic/bokuNoHero.png',
    ),
    Comic(
      title: 'Jujutsu Kaisen',
      subtitle: 'chapter 271 • Completed',
      imageUrl: 'assets/images/newcomic/jujusuKaisen.png',
    ),
  ];

  Map<String, String> greetingMessage() {
    DateTime now = DateTime.now();
    int hour = now.hour;
    String formattedTime =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

    String greeting;

    if (hour >= 5 && hour < 12) {
      greeting = "Ohayō!";
    } else if (hour >= 12 && hour < 15) {
      greeting = "Konnichiwa!";
    } else if (hour >= 15 && hour < 18) {
      greeting = "Yūgata!";
    } else {
      greeting = "Konbanwa!";
    }

    return {"greeting": greeting, "time": formattedTime};
  }

  MyHomePage({super.key, required this.userEmail, required this.userPass});

  @override
  Widget build(BuildContext context) {
    final message = greetingMessage();
    return Scaffold(
      backgroundColor: const Color(0xFFE6F2FF),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message["greeting"]!,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        (userEmail),
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),

                  Text(
                    (message['time']!),
                    style: const TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            ComicCarousel(comics: sampleComics),
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.pushReplacementNamed(context, '/');
            //   },
            //   child: const Text('Logout'),
            // ),

            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Daftar Anime Favorit:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            Expanded(
              child: ListView.builder(
                itemCount: animeList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              AnimeDetailPage(title: animeList[index]),
                        ),
                      );
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      elevation: 4,
                      color: const Color(0xFFE5F3FF),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.auto_stories,
                              color: Color(0xFF005FB3),
                              size: 28,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                animeList[index],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              color: Color(0xFF005FB3),
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}