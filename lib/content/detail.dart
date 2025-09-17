import 'package:flutter/material.dart';

class AnimeDetailPage extends StatelessWidget {
  final String title;

  const AnimeDetailPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          "Detail dari $title",
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}