import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mango/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:mango/features/home/presentation/widgets/comic_list_view.dart'; 

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
      body: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, state) {
          if (state.status == FavoritesStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (state.status == FavoritesStatus.failure) {
            return Center(child: Text(state.errorMessage ?? 'Failed to load favorites'));
          }
          
          if (state.favorites.isEmpty) {
            return const Center(
              child: Text(
                'No favorites yet!',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          // Using the refactored ComicListView
          return ComicListView(comics: state.favorites);
        },
      ),
    );
  }
}
