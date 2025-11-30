import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mango/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:mango/features/favorites/domain/usecases/add_favorite.dart';
import 'package:mango/features/favorites/domain/usecases/get_favorites.dart';
import 'package:mango/features/favorites/domain/usecases/remove_favorite.dart';
import 'package:mango/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:mango/features/home/presentation/screens/comic_detail_screen.dart';
import 'package:mango/features/comic_detail/presentation/cubit/comic_detail_cubit.dart';
import 'package:mango/features/comic_detail/presentation/cubit/comic_detail_state.dart';
import 'package:mango/injection.dart';

class ComicDetailRoute extends StatelessWidget {
  final String comicId;
  const ComicDetailRoute({super.key, required this.comicId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<ComicDetailRouteCubit>()
            ..loadComic(comicId),
      child: BlocBuilder<ComicDetailRouteCubit, ComicDetailRouteState>(
        builder: (context, state) {
          if (state is ComicDetailRouteLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (state is ComicDetailRouteError) {
            return Scaffold(
              appBar: AppBar(title: const Text('Comic')),
              body: Center(child: Text(state.message)),
            );
          }

          if (state is ComicDetailRouteSuccess) {
            return BlocProvider(
              create: (context) => FavoritesCubit(
                getFavorites: GetFavorites(context.read<FavoritesRepository>()),
                addFavorite: AddFavorite(context.read<FavoritesRepository>()),
                removeFavorite: RemoveFavorite(context.read<FavoritesRepository>()),
              ),
              child: ComicDetailScreen(comic: state.comic),
            );
          }

          return const Scaffold(
            body: Center(child: Text('An unknown error occurred.')),
          );
        },
      ),
    );
  }
}
