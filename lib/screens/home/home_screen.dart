import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mango/data/manga/manga_data.dart';
import 'package:mango/data/manhua/manhua_data.dart';
import 'package:mango/data/manhwa/manhwa_data.dart';
import 'package:mango/models/comic.dart';
import 'package:mango/widgets/comic_list_view.dart';
import 'package:mango/widgets/new_comic.dart';

class MyHomePage extends StatefulWidget {
  final String userEmail;
  final String userPass;

  const MyHomePage({
    super.key,
    required this.userEmail,
    required this.userPass,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late String greeting;
  late String time;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    _updateGreeting();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateGreeting();
    });
  }

  void _updateGreeting() {
    final now = DateTime.now();
    final hour = now.hour;

    String newGreeting;
    if (hour >= 5 && hour < 12) {
      newGreeting = "Ohayō!";
    } else if (hour >= 12 && hour < 15) {
      newGreeting = "Konnichiwa!";
    } else if (hour >= 15 && hour < 18) {
      newGreeting = "Yūgata!";
    } else {
      newGreeting = "Konbanwa!";
    }

    final newTime =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

    setState(() {
      greeting = newGreeting;
      time = newTime;
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  List<Comic> get allComics => [...mangaList, ...manhwaList, ...manhuaList];

  @override
  Widget build(BuildContext context) {
    final sampleComics = [
      NewComic(
        id: 'op001',
        title: 'One Piece',
        subtitle: 'Chapter 1107 • Updated',
        imageUrl: 'assets/images/newcomic/onePiece.png',
      ),
      NewComic(
        id: 'bnh001',
        title: 'Boku no Hero',
        subtitle: 'Chapter 430 • Completed',
        imageUrl: 'assets/images/newcomic/bokuNoHero.png',
      ),
      NewComic(
        id: 'jjk001',
        title: 'Jujutsu Kaisen',
        subtitle: 'Chapter 271 • Completed',
        imageUrl: 'assets/images/newcomic/jujusuKaisen.png',
      ),
    ];

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
                        greeting,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.userEmail,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    time,
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
                      color: const Color(0xFFFFFFFF),
                      child: TabBar(
                        labelColor: Colors.blue,
                        unselectedLabelColor: Colors.grey,
                        tabs: const [
                          Tab(icon: Icon(Icons.library_books), text: 'All'),
                          Tab(icon: Icon(Icons.menu_book), text: 'Manga'),
                          Tab(
                            icon: Icon(Icons.chrome_reader_mode),
                            text: 'Manhwa',
                          ),
                          Tab(icon: Icon(Icons.auto_stories), text: 'Manhua'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          ComicListView(comics: allComics),
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
