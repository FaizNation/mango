import 'package:flutter/material.dart';
import '../models/comic.dart';
import 'comic_detail_screen.dart';

class ComicListView extends StatelessWidget {
  final List<Comic> comics;

  const ComicListView({super.key, required this.comics});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: comics.length,
      padding: const EdgeInsets.all(8),
      itemBuilder: (context, index) {
        final comic = comics[index];
        return Card(
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ComicDetailScreen(comic: comic),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Comic Cover
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      comic.coverImage,
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
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Comic Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          comic.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          comic.author,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          comic.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        // Genres and Rating
                        Row(
                          children: [
                            Expanded(
                              child: Wrap(
                                spacing: 4,
                                runSpacing: 4,
                                children: comic.genres.map((genre) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      // ignore: deprecated_member_use
                                      color: Colors.blue.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      genre,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 20,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  comic.rating.toString(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
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
