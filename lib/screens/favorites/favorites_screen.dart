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
      // Apply the responsive centering pattern here
      body: Center(
        child: Container(
          // On wider screens, this constrains the content to a max width of 700.
          // On smaller screens (less than 700), this has no effect.
          constraints: const BoxConstraints(maxWidth: 700),
          child: Consumer<FavoritesProvider>(
            builder: (context, favoritesProvider, child) {
              // If the favorites list is empty, display a message
              if (favoritesProvider.favorites.isEmpty) {
                return const Center(
                  child:
                      Text('No favorites yet!', style: TextStyle(fontSize: 18)),
                );
              }
              // Otherwise, display the list of favorite comics
              return ComicListView(comics: favoritesProvider.favorites);
            },
          ),
        ),
      ),
    );
  }
}
