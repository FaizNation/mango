import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:mango/cubits/screens/comic_detail_cubit.dart';
import 'package:mango/cubits/screens/comic_detail_state.dart';
import 'package:mango/screens/chapter_detail_screen.dart';
import 'package:mango/providers/history_provider.dart';
import 'package:mango/models/comic/comic.dart';
import 'package:mango/models/chapter.dart';
import 'package:mango/utils/image_proxy.dart';
import 'package:mango/providers/favorites_provider.dart';
import 'package:mango/services/api_service.dart' as service;

class ComicDetailScreen extends StatefulWidget {
  final Comic comic;

  const ComicDetailScreen({super.key, required this.comic});

  @override
  State<ComicDetailScreen> createState() => _ComicDetailScreenState();
}

class _ComicDetailScreenState extends State<ComicDetailScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        final history = context.read<HistoryProvider>();
        history.addEntry(
          comicId: widget.comic.id.toString(),
          title: widget.comic.titleEnglish ?? widget.comic.title,
          genres: widget.comic.genres,
          imageUrl: widget.comic.imageUrl,
          author: widget.comic.author,
          synopsis: widget.comic.synopsis,
        );
      } catch (_) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ComicDetailCubit(service.ApiService())
            ..fetchChapters(int.parse(widget.comic.id)),
      child: Scaffold(
        backgroundColor: const Color(0xFFE6F2FF),
        body: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 700),
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 300,
                  pinned: true,
                  backgroundColor: const Color(0xFFE6F2FF),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Image.network(
                      ImageProxy.proxyWithOptions(
                        widget.comic.imageUrl,
                        width: 800,
                        height: 600,
                        fit: 'cover',
                        quality: 90,
                      ),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          child: const Icon(Icons.broken_image, size: 50),
                        );
                      },
                    ),
                    title: Text(
                      widget.comic.titleEnglish ?? widget.comic.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 1),
                            blurRadius: 3.0,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ],
                      ),
                    ),
                    titlePadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (widget.comic.author != null)
                              Expanded(
                                child: Text(
                                  'By ${widget.comic.author}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        if (widget.comic.genres.isNotEmpty) ...[
                          const Text(
                            'Genres',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: widget.comic.genres.map((genre) {
                              return Chip(
                                label: Text(genre),

                                // ignore: deprecated_member_use
                                backgroundColor: Colors.blue.withOpacity(0.1),
                                labelStyle: const TextStyle(color: Colors.blue),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 24),
                        ],

                        const Text(
                          'Details',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),

                        ...widget.comic
                            .getAdditionalInfo()
                            .entries
                            .where((e) => e.value != null)
                            .map(
                              (e) => Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${e.key}: ',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        e.value.toString(),
                                        style: const TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                        if (widget.comic.status != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              children: [
                                const Text(
                                  'Status: ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(widget.comic.status!),
                              ],
                            ),
                          ),
                        if (widget.comic.chapters != null)
                          Row(
                            children: [
                              const Text(
                                'Total Chapters: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('${widget.comic.chapters}'),
                            ],
                          ),

                        const SizedBox(height: 24),

                        if (widget.comic.synopsis != null) ...[
                          const Text(
                            'Synopsis',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.comic.synopsis!,
                            style: const TextStyle(fontSize: 16, height: 1.5),
                          ),
                          const SizedBox(height: 16),
                        ],

                        Row(
                          children: [
                            Expanded(
                              child: Consumer<FavoritesProvider>(
                                builder: (context, favoritesProvider, child) {
                                  final isFavorite = favoritesProvider
                                      .isFavorite(widget.comic);
                                  return ElevatedButton.icon(
                                    onPressed: () {
                                      favoritesProvider.toggleFavorite(
                                        widget.comic,
                                      );
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            isFavorite
                                                ? 'Removed from favorites'
                                                : 'Added to favorites',
                                          ),
                                          duration: const Duration(seconds: 2),
                                        ),
                                      );
                                    },
                                    icon: Icon(
                                      isFavorite
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: isFavorite ? Colors.pink : null,
                                    ),
                                    label: Text(
                                      isFavorite
                                          ? 'Remove from Favorites'
                                          : 'Add to Favorites',
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            if (widget.comic.chapters != null) ...[
                              const SizedBox(width: 16),
                              Expanded(
                                child:
                                    BlocBuilder<
                                      ComicDetailCubit,
                                      ComicDetailState
                                    >(
                                      builder: (context, state) {
                                        final loadedChapters =
                                            (state is ComicDetailLoaded)
                                            ? state.chapters
                                            : <Chapter>[];

                                        return ElevatedButton.icon(
                                          onPressed: loadedChapters.isNotEmpty
                                              ? () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ChapterDetailScreen(
                                                            chapter:
                                                                loadedChapters[0],
                                                            allChapters:
                                                                loadedChapters,
                                                          ),
                                                    ),
                                                  );
                                                }
                                              : null,
                                          icon: const Icon(Icons.book),
                                          label: const Text('Start Reading'),
                                          style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 12,
                                            ),
                                            backgroundColor: Theme.of(
                                              context,
                                            ).primaryColor,
                                            foregroundColor: Colors.white,
                                          ),
                                        );
                                      },
                                    ),
                              ),
                            ],
                          ],
                        ),

                        const SizedBox(height: 24),

                        BlocBuilder<ComicDetailCubit, ComicDetailState>(
                          builder: (context, state) {
                            if (state is ComicDetailLoading ||
                                state is ComicDetailInitial) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            if (state is ComicDetailError) {
                              return Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  state.message,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              );
                            }

                            if (state is ComicDetailLoaded) {
                              if (state.chapters.isNotEmpty) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Chapters',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: state.chapters.length,
                                      itemBuilder: (context, index) {
                                        final chapter = state.chapters[index];
                                        return Card(
                                          margin: const EdgeInsets.symmetric(
                                            vertical: 4,
                                          ),
                                          child: ListTile(
                                            title: Text(chapter.title),
                                            trailing: const Icon(
                                              Icons.chevron_right,
                                            ),
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ChapterDetailScreen(
                                                        chapter: chapter,
                                                        allChapters:
                                                            state.chapters,
                                                      ),
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                );
                              } else {
                                return const Center(
                                  child: Text("No chapters found."),
                                );
                              }
                            }

                            return const SizedBox.shrink();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
