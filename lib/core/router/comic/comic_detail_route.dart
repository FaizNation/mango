import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // <-- Impor
// import '../../models/comic/comic.dart'; // <-- Tidak perlu
import 'package:mango/features/home/presentation/screens/comic_detail_screen.dart';

// Impor Cubit & State baru
import 'package:mango/features/comic_detail/presentation/cubit/comic_detail_cubit.dart';
import 'package:mango/features/comic_detail/presentation/cubit/comic_detail_state.dart';
import 'package:mango/injection.dart';

// 1. Ubah menjadi StatelessWidget
class ComicDetailRoute extends StatelessWidget {
  final String comicId;

  const ComicDetailRoute({super.key, required this.comicId});

  // HAPUS: Seluruh _ComicDetailRouteState
  // HAPUS: initState(), _load(), _loading, _error, dll.

  @override
  Widget build(BuildContext context) {
    // 2. Sediakan Cubit
    return BlocProvider(
      create: (context) =>
          sl<ComicDetailRouteCubit>()
            ..loadComic(comicId), // Panggil load di sini
      // 3. Gunakan BlocBuilder untuk menampilkan UI
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
            // Jika sukses, tampilkan screen yang sesungguhnya
            return ComicDetailScreen(comic: state.comic);
          }

          // Fallback (seharusnya tidak pernah terjadi)
          return const Scaffold(
            body: Center(child: Text('An unknown error occurred.')),
          );
        },
      ),
    );
  }
}
