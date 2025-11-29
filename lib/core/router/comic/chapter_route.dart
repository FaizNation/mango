import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; 
import 'package:mango/features/reader/presentation/screens/chapter_detail_screen.dart';
import 'package:mango/features/reader/presentation/cubit/chapter_route_cubit.dart';
import 'package:mango/injection.dart';  

class ChapterRoute extends StatelessWidget {
  final String comicId;
  final String chapterId;

  const ChapterRoute({
    super.key,
    required this.comicId,
    required this.chapterId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<ChapterRouteCubit>()
            ..loadChapterData(comicId, chapterId), 
      child: BlocBuilder<ChapterRouteCubit, ChapterRouteState>(
        builder: (context, state) {
          if (state is ChapterRouteLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (state is ChapterRouteError) {
            return Scaffold(
              appBar: AppBar(title: const Text('Chapter')),
              body: Center(child: Text(state.message)),
            );
          }

          if (state is ChapterRouteSuccess) {
            return ChapterDetailScreen(
              chapter: state.chapter,
              allChapters: state.allChapters,
            );
          }

          return const Scaffold(
            body: Center(child: Text('Unknown error occurred')),
          );
        },
      ),
    );
  }
}
