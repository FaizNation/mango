import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mango/core/utils/image_proxy.dart';
import 'package:mango/features/home/domain/entities/comic_entity.dart';
import 'package:sizer/sizer.dart';

class ComicListView extends StatelessWidget {
  final List<ComicEntity> comics;
  final bool isLoading;
  final VoidCallback? onLoadMore;
  final String? error;

  const ComicListView({
    super.key,
    required this.comics,
    this.isLoading = false,
    this.onLoadMore,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onLoadMore,
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    }

    if (comics.isEmpty && isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (comics.isEmpty) {
      return const Center(child: Text('No comics found'));
    }

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification is ScrollEndNotification &&
                notification.metrics.pixels >=
                    notification.metrics.maxScrollExtent &&
                !isLoading &&
                onLoadMore != null) {
              onLoadMore!();
            }
            return true;
          },
          child: ListView.builder(
            itemCount: comics.length + (isLoading ? 1 : 0),
            padding: const EdgeInsets.all(8),
            itemBuilder: (context, index) {
              if (index == comics.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              final comic = comics[index];
              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: InkWell(
                  onTap: () {
                    context.go('/comic/${Uri.encodeComponent(comic.id)}');
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            ImageProxy.proxyWithOptions(
                              comic.imageUrl,
                              width: 100,
                              height: 150,
                              fit: 'cover',
                            ),
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
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                comic.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              if (comic.author != null)
                                Text(
                                  comic.author!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              const SizedBox(height: 8),
                              Text(
                                comic.synopsis ?? 'No synopsis available',
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
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
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
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
          ),
        ),
      ),
    );
  }
}
