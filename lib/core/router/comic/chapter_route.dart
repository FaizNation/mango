import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // <-- Impor
import 'package:mango/core/router/cubits/chapter_state.dart';
// import '../../models/chapter.dart'; // <-- Tidak perlu
import 'package:mango/features/reader/presentation/screens/chapter_detail_screen.dart';

// Impor Cubit & State baru
import 'package:mango/core/router/cubits/chapter_cubit.dart';
import 'package:mango/injection.dart';

// 1. Ubah menjadi StatelessWidget
class ChapterRoute extends StatelessWidget {
  final String comicId;
  final String chapterId;

  const ChapterRoute({
    super.key,
    required this.comicId,
    required this.chapterId,
  });

  // HAPUS: Seluruh _ChapterRouteState
  // HAPUS: initState(), _load(), _loading, _error, dll.

  @override
  Widget build(BuildContext context) {
    // 2. Sediakan Cubit
    return BlocProvider(
      create: (context) =>
          sl<ChapterRouteCubit>()
            ..loadChapterData(comicId, chapterId), // Panggil load di sini
      // 3. Gunakan BlocBuilder untuk menampilkan UI
      child: BlocBuilder<ChapterRouteCubit, ChapterRouteState>(
        builder: (context, state) {
          // Bandingkan dengan 'build' Anda yang lama, logikanya sama persis!

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
            // Jika sukses, tampilkan screen yang sesungguhnya
            return ChapterDetailScreen(
              chapter: state.chapter,
              allChapters: state.allChapters,
            );
          }

          // Fallback jika terjadi state aneh (seharusnya tidak terjadi)
          return const Scaffold(
            body: Center(child: Text('Unknown error occurred')),
          );
        },
      ),
    );
  }
}
