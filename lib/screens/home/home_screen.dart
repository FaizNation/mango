
import 'package:flutter/material.dart';
import 'package:mango/data/manga/manga_data.dart';
import 'package:mango/data/manhua/manhua_data.dart';
import 'package:mango/data/manhwa/manhwa_data.dart';
import 'package:mango/models/comic.dart';
import 'package:mango/widgets/comic_list_view.dart';
import 'package:mango/widgets/new_comic.dart';

class MyHomePage extends StatelessWidget {
  final String userEmail;
  final String userPass;

  final sampleComics = [
    NewComic(
      title: 'One piece',
      subtitle: 'Chapter 1107 • Updated',
      imageUrl: 'assets/images/newcomic/onePiece.png',
    ),
    NewComic(
      title: 'Boku no Hero',
      subtitle: 'chapter 430 • Completed',
      imageUrl: 'assets/images/newcomic/bokuNoHero.png',
    ),
    NewComic(
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

  // Getter to combine all comics
  List<Comic> get allComics => [...mangaList, ...manhwaList, ...manhuaList];

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

            DefaultTabController(
              length: 4,
              child: Expanded(
                child: Column(
                  children: [
                    Container(
                      color: Colors.white,
                      child: TabBar(
                        labelColor: Colors.blue,
                        unselectedLabelColor: Colors.grey,
                        isScrollable: false,
                        tabs: [
                          Tab(icon: Icon(Icons.library_books), text: 'All'),
                          Tab(icon: Icon(Icons.menu_book), text: 'Manga'),
                          Tab(icon: Icon(Icons.chrome_reader_mode), text: 'Manhwa'),
                          Tab(icon: Icon(Icons.auto_stories), text: 'Manhua'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          // All Comics Tab
                          ComicListView(comics: allComics),
                          // Individual Category Tabs
                          ComicListView(comics: mangaList),
                          ComicListView(comics: manhwaList),
                          ComicListView(comics: manhuaList),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
