import 'package:mango/screens/chapter_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/history_provider.dart';
import '../models/comic/comic.dart';
import '../models/chapter.dart';
import '../utils/image_proxy.dart';
import '../providers/favorites_provider.dart';
import '../services/api_service.dart' as service;

class ComicDetailScreen extends StatefulWidget {
  final Comic comic;

  const ComicDetailScreen({super.key, required this.comic});

  @override
  State<ComicDetailScreen> createState() => _ComicDetailScreenState();
}

class _ComicDetailScreenState extends State<ComicDetailScreen> {
  List<Chapter> chapters = [];
  bool _isLoading = false;
  String? _error;
  final service.ApiService _apiService = service.ApiService();

  @override
  void initState() {
    super.initState();
    _loadChapters();

    // Record in history after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        final history = context.read<HistoryProvider>();
        history.addEntry(
          comicId: widget.comic.id.toString(),
          title: widget.comic.titleEnglish ?? widget.comic.title,
          genres: widget.comic.genres,
        );
      } catch (_) {
        // provider not registered or other error - ignore silently
      }
    });
  }

  Future<void> _loadChapters() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // fetch chapters from API using manga id
      final fetched = await _apiService.getChapters(widget.comic.id);
      chapters = fetched;
    } catch (e) {
      setState(() {
        _error = 'Failed to load chapters: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          // if (widget.comic.rating > 0)
                          //   Row(
                          //     children: [
                          //       const Icon(Icons.star, color: Colors.amber),
                          //       const SizedBox(width: 4),
                          //       Text(
                          //         widget.comic.rating.toStringAsFixed(1),
                          //         style: const TextStyle(
                          //           fontSize: 18,
                          //           fontWeight: FontWeight.bold,
                          //         ),
                          //       ),
                          //     ],
                          //   ),
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
                      // Add additional info from Comic subclasses
                      ...widget.comic
                          .getAdditionalInfo()
                          .entries
                          .where(
                            (e) => e.value != null,
                          ) // Filter out null values
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
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
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
                                final isFavorite = favoritesProvider.isFavorite(
                                  widget.comic,
                                );
                                return ElevatedButton.icon(
                                  onPressed: () {
                                    favoritesProvider.toggleFavorite(
                                      widget.comic,
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
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
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  if (chapters.isNotEmpty) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ChapterDetailScreen(
                                              chapter: chapters[0],
                                              allChapters: chapters,
                                            ),
                                      ),
                                    );
                                  }
                                },
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
                              ),
                            ),
                          ],
                        ],
                      ),

                      const SizedBox(height: 24),

                      if (_error != null)
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            _error!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        )
                      else if (_isLoading)
                        const Center(child: CircularProgressIndicator())
                      else if (chapters.isNotEmpty) ...[
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
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: chapters.length,
                          itemBuilder: (context, index) {
                            final chapter = chapters[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              child: ListTile(
                                title: Text(chapter.title),
                                // subtitle: Text(
                                //   chapter.publishedAt != null
                                //       ? 'Chapter ${chapter.chapterNumber} • ${_formatDate(chapter.publishedAt!)}'
                                //       : 'Chapter ${chapter.chapterNumber}',
                                // ),
                                trailing: const Icon(Icons.chevron_right),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChapterDetailScreen(
                                        chapter: chapter,
                                        allChapters: chapters,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
