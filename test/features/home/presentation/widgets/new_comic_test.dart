
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mango/features/home/presentation/widgets/new_comic.dart';

void main() {
  testWidgets('ComicCarousel shows a list of comics', (WidgetTester tester) async {
    final comics = [
      NewComic(id: '1', title: 'Comic 1', imageUrl: 'assets/images/newcomic/tgde.jpg'),
      NewComic(id: '2', title: 'Comic 2', imageUrl: 'assets/images/newcomic/mr.jpg'),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ComicCarousel(comics: comics),
        ),
      ),
    );

    expect(find.text('Comic 1'), findsOneWidget);
    expect(find.text('Comic 2'), findsOneWidget);
  });
}
