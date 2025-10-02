import 'package:flutter/material.dart';
import 'package:mango/providers/favorites_provider.dart';
import 'package:mango/widgets/comic_list_view.dart';

import 'package:provider/provider.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F2FF),
      appBar: AppBar(
        title: const Text('My Favorites'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFE6F2FF),
      ),
      body: Consumer<FavoritesProvider>(
        builder: (context, favoritesProvider, child) {
          if (favoritesProvider.favorites.isEmpty) {
            return const Center(
              child: Text('No favorites yet!', style: TextStyle(fontSize: 18)),
            );
          }
          return ComicListView(comics: favoritesProvider.favorites);
        },
      ),
    );
  }
}
