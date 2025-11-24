import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mango/core/domain/entities/chapter.dart';
import '../cubit/chapter_cubit.dart';
import 'package:mango/injection.dart';
import 'package:mango/features/reader/domain/usecases/get_chapter_images.dart';

class ChapterDetailScreen extends StatefulWidget {
  final Chapter chapter;
  final List<Chapter> allChapters;

  const ChapterDetailScreen({
    super.key,
    required this.chapter,
    required this.allChapters,
  });

  @override
  State<ChapterDetailScreen> createState() => _ChapterDetailScreenState();
}

class _ChapterDetailScreenState extends State<ChapterDetailScreen> {
  late final ChapterCubit _cubit;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _cubit = ChapterCubit(
      initialChapter: widget.chapter,
      allChapters: widget.allChapters,
      getChapterImages: sl<GetChapterImages>(),
    );
    // kick off image load for initial chapter
    _cubit.ensureImagesForChapter(widget.chapter);
  }

  @override
  void dispose() {
    _cubit.close();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocListener<ChapterCubit, ChapterState>(
        listenWhen: (prev, curr) =>
            prev.currentChapter.id != curr.currentChapter.id,
        listener: (context, state) {
          // scroll to top when chapter changes
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_scrollController.hasClients) _scrollController.jumpTo(0);
          });
        },
        child: BlocBuilder<ChapterCubit, ChapterState>(
          builder: (context, state) {
            final current = state.currentChapter;
            int currentChapterIndex = state.allChapters.indexWhere(
              (c) => c.id == current.id,
            );
            if (currentChapterIndex == -1) currentChapterIndex = 0;
            final hasNextChapter = currentChapterIndex > 0;
            final hasPreviousChapter =
                currentChapterIndex < state.allChapters.length - 1;

            return Scaffold(
              appBar: AppBar(
                title: Text(current.title),
                centerTitle: true,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.list),
                    onPressed: () {
                      _showChaptersList(context);
                    },
                  ),
                ],
              ),
              body: Stack(
                children: [
                  _buildBodyFromState(state),
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (hasNextChapter)
                          FloatingActionButton(
                            heroTag: 'nextChapter',
                            onPressed: () {
                              context.read<ChapterCubit>().navigateToChapter(
                                state.allChapters[currentChapterIndex - 1],
                              );
                            },
                            child: const Icon(Icons.keyboard_arrow_up),
                          ),
                        const SizedBox(height: 8),
                        if (hasPreviousChapter)
                          FloatingActionButton(
                            heroTag: 'prevChapter',
                            onPressed: () {
                              context.read<ChapterCubit>().navigateToChapter(
                                state.allChapters[currentChapterIndex + 1],
                              );
                            },
                            child: const Icon(Icons.keyboard_arrow_down),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBodyFromState(ChapterState state) {
    if (state.error != null) {
      return Center(
        child: Text(state.error!, style: const TextStyle(color: Colors.red)),
      );
    }
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.currentChapter.images.isEmpty) {
      return const Center(child: Text('No images available'));
    }

    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        children: state.currentChapter.images.map((imageUrl) {
          return InteractiveViewer(
            minScale: 1.0,
            maxScale: 3.0,
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
              width: double.infinity,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return SizedBox(
                  height: 400,
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return const SizedBox(
                  height: 400,
                  child: Center(child: Icon(Icons.broken_image, size: 64)),
                );
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showChaptersList(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => BlocProvider.value(
        value: _cubit,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          height: MediaQuery.of(context).size.height * 0.6,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Chapters',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.allChapters.length,
                  itemBuilder: (context, index) {
                    final chapter = widget.allChapters[index];
                    // get current id from cubit
                    final currentId = context
                        .read<ChapterCubit>()
                        .state
                        .currentChapter
                        .id;
                    bool isCurrentChapter = chapter.id == currentId;

                    return ListTile(
                      title: Text(
                        chapter.title,
                        style: TextStyle(
                          fontWeight: isCurrentChapter
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      tileColor: isCurrentChapter
                          ? Theme.of(context).primaryColor.withAlpha(25)
                          : null,
                      onTap: () {
                        Navigator.pop(context);
                        context.read<ChapterCubit>().navigateToChapter(chapter);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
