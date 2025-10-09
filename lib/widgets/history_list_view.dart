import 'package:flutter/material.dart';
import 'package:mango/models/history_entry.dart';
import 'package:mango/widgets/comic_detail_screen.dart';
import 'package:mango/widgets/new_comic.dart' show findComicById;
import 'package:mango/models/comic.dart';

class HistoryListView extends StatelessWidget {
  final List<HistoryEntry> entries;

  const HistoryListView({super.key, required this.entries});

  String _formatDate(DateTime? dt) {
    if (dt == null) return '';
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: entries.length,
      padding: const EdgeInsets.all(8),
      itemBuilder: (context, index) {
        final entry = entries[index];
        return Card(
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: InkWell(
            onTap: () {
              final comicId = entry.id;
              final found = findComicById(comicId, context);
              if (found != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ComicDetailScreen(comic: found),
                  ),
                );
                return;
              }

              final minimal = Comic(
                id: comicId,
                title: entry.title,
                author: entry.author ?? 'Unknown',
                description: entry.description ?? 'No description available.',
                coverImage: entry.coverImage ?? '',
                rating: 0.0,
                genres: <String>[],
              );

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ComicDetailScreen(comic: minimal),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child:
                        entry.coverImage != null && entry.coverImage!.isNotEmpty
                        ? Image.network(
                            entry.coverImage!,
                            width: 100,
                            height: 150,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 100,
                                height: 150,
                                color: Colors.grey[200],
                                child: const Icon(Icons.broken_image),
                              );
                            },
                          )
                        : Container(
                            width: 100,
                            height: 150,
                            color: Colors.grey[200],
                            child: const Icon(Icons.image_not_supported),
                          ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          entry.author ?? '',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          entry.description ?? '',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Opened: ${_formatDate(entry.openedAt)}',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
