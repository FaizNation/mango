import 'package:flutter/material.dart';

class NewComic {
  final String title;
  final String imageUrl;
  final String subtitle;

  NewComic({required this.title, required this.imageUrl, this.subtitle = ''});
}

class ComicCarousel extends StatelessWidget {
  final List<NewComic> comics;

  const ComicCarousel({super.key, required this.comics});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return SizedBox(
      height: w * 0.45,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: comics.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final c = comics[index];
          return SizedBox(
            width: 380,
            height: 130,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    c.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, err, st) => Container(
                      color: Colors.grey[300],
                      child: const Center(child: Icon(Icons.image, size: 48)),
                    ),
                  ),

                  Positioned(
                    left: 12,
                    bottom: 12,
                    right: 12,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          c.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (c.subtitle.isNotEmpty)
                          Text(
                            c.subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              // ignore: deprecated_member_use
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 13,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
