import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; 
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
            return ComicDetailScreen(comic: state.comic);
          }

          return const Scaffold(
            body: Center(child: Text('An unknown error occurred.')),
          );
        },
      ),
    );
  }
}
