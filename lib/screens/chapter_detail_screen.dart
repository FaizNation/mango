import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/chapter.dart';

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
  late Chapter _currentChapter;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _currentChapter = widget.chapter;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _navigateToChapter(Chapter chapter) {
    setState(() {
      _currentChapter = chapter;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    int currentChapterIndex = widget.allChapters.indexOf(_currentChapter);
    bool hasNextChapter = currentChapterIndex > 0;
    bool hasPreviousChapter =
        currentChapterIndex < widget.allChapters.length - 1;

    return Scaffold(
      backgroundColor: const Color(0xFFE6F2FF),
      appBar: AppBar(
        title: Text(_currentChapter.title),
        centerTitle: true,
        backgroundColor: const Color(0xFFE6F2FF),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {
              _showChaptersList(context);
            },
          ),
        ],
      ),
      body: Center(
        child: Container(
          // On wider screens, this constrains the content to a max width of 700.
          // On smaller screens (less than 700), this has no effect.
          constraints: const BoxConstraints(maxWidth: 700),
          child: Stack(
            children: [
              SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: _currentChapter.images.map((imageUrl) {
                    return InteractiveViewer(
                      minScale: kIsWeb ? 1.0 : 1.0,
                      maxScale: kIsWeb ? 1.0 : 3.0,
                      scaleEnabled: !kIsWeb,
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
                                value: loadingProgress.expectedTotalBytes !=
                                        null
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
                            child: Center(
                              child: Icon(Icons.broken_image, size: 64),
                            ),
                          );
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
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
                          _navigateToChapter(
                            widget.allChapters[currentChapterIndex - 1],
                          );
                        },
                        child: const Icon(Icons.keyboard_arrow_up),
                      ),
                    const SizedBox(height: 8),
                    if (hasPreviousChapter)
                      FloatingActionButton(
                        heroTag: 'prevChapter',
                        onPressed: () {
                          _navigateToChapter(
                            widget.allChapters[currentChapterIndex + 1],
                          );
                        },
                        child: const Icon(Icons.keyboard_arrow_down),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showChaptersList(BuildContext context) {
    showModalBottomSheet(
      context: context,
      // Center the bottom sheet content as well for desktop
      builder: (context) => Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 700),
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                    bool isCurrentChapter = chapter.id == _currentChapter.id;

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
                          // ignore: deprecated_member_use
                          ? Theme.of(context).primaryColor.withOpacity(0.1)
                          : null,
                      onTap: () {
                        Navigator.pop(context);
                        _navigateToChapter(chapter);
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
