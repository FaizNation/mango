import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // <-- Impor Bloc
import 'package:provider/provider.dart';

// Impor file Cubit & State yang baru kita buat
import 'package:mango/cubits/screens/comic_detail_cubit.dart';
import 'package:mango/cubits/screens/comic_detail_state.dart';


import 'package:mango/screens/chapter_detail_screen.dart';
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
  // HAPUS SEMUA VARIABEL STATE LAMA:
  // List<Chapter> chapters = []; <-- Hapus
  // bool _isLoading = false; <-- Hapus
  // String? _error; <-- Hapus
  // final service.ApiService _apiService = service.ApiService(); <-- Hapus
  // Future<void> _loadChapters() async { ... } <-- Hapus

  @override
  void initState() {
    super.initState();
    // JANGAN panggil fetchChapters di sini, karena Cubit belum tersedia.
    // Kita akan memanggilnya di dalam BlocProvider.create

    
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

  @override
  Widget build(BuildContext context) {
    // 1. Sediakan Cubit untuk widget tree di bawahnya
    return BlocProvider(
      create: (context) => ComicDetailCubit(
        service.ApiService(), // Buat instance ApiService di sini
      )..fetchChapters(int.parse(widget.comic.id)), // Panggil fetchChapters saat Cubit dibuat
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
                          // ... (Bagian Genre tetap sama)
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
                        // ... (Bagian Details tetap sama)
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
                          // ... (Bagian Status tetap sama)
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
                          // ... (Bagian Total Chapters tetap sama)
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
                          // ... (Bagian Synopsis tetap sama)
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
                                // ... (Bagian FavoriteProvider tetap sama)
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
                                // 2. Gunakan BlocBuilder untuk tombol "Start Reading"
                                child: BlocBuilder<ComicDetailCubit, ComicDetailState>(
                                  builder: (context, state) {
                                    // Ambil list chapter JIKA state-nya Loaded
                                    final loadedChapters =
                                        (state is ComicDetailLoaded)
                                            ? state.chapters
                                            : <Chapter>[];

                                    return ElevatedButton.icon(
                                      onPressed: loadedChapters.isNotEmpty
                                          ? () {
                                              // Navigasi dengan data dari state
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ChapterDetailScreen(
                                                    chapter: loadedChapters[0],
                                                    allChapters: loadedChapters,
                                                  ),
                                                ),
                                              );
                                            }
                                          : null, // Nonaktifkan tombol jika chapter belum load
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

                        // 3. Ganti blok if/else _isLoading dengan BlocBuilder
                        BlocBuilder<ComicDetailCubit, ComicDetailState>(
                          builder: (context, state) {
                            // Tampilkan UI berdasarkan state saat ini
                            if (state is ComicDetailLoading || state is ComicDetailInitial) {
                              return const Center(child: CircularProgressIndicator());
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
                                // Jika berhasil dan ada chapter, tampilkan list
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
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: state.chapters.length,
                                      itemBuilder: (context, index) {
                                        final chapter = state.chapters[index];
                                        return Card(
                                          margin: const EdgeInsets.symmetric(vertical: 4),
                                          child: ListTile(
                                            title: Text(chapter.title),
                                            trailing: const Icon(Icons.chevron_right),
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ChapterDetailScreen(
                                                    chapter: chapter,
                                                    allChapters: state.chapters,
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
                                // Jika berhasil tapi tidak ada chapter
                                return const Center(child: Text("No chapters found."));
                              }
                            }
                            
                            // State default jika terjadi sesuatu (seharusnya tidak terjadi)
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