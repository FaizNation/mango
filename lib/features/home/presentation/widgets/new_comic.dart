import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    ...super.dragDevices,
    PointerDeviceKind.mouse,
  };
}

class NewComic {
  final String title;
  final String imageUrl;
  final String subtitle;
  final String id;

  NewComic({
    required this.title,
    required this.imageUrl,
    this.subtitle = '',
    required this.id,
  });
}

class ComicCarousel extends StatelessWidget {
  final List<NewComic> comics;

  const ComicCarousel({super.key, required this.comics});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 600;
        final double carouselHeight = isDesktop ? 300 : constraints.maxWidth * 0.45;
        final double itemWidth = isDesktop ? 450 : 380;
        final double titleFontSize = isDesktop ? 22 : 18;
        final double subtitleFontSize = isDesktop ? 16 : 13;

        return SizedBox(
          height: carouselHeight,
          child: ScrollConfiguration(
            behavior: MyCustomScrollBehavior(),
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: comics.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final c = comics[index];
                return GestureDetector(
                  onTap: () {
                    context.push('/comic/${c.id}');
                  },
                  child: SizedBox(
                    width: itemWidth,
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
                              child: const Center(
                                child: Icon(Icons.image, size: 48),
                              ),
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
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: titleFontSize,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                if (c.subtitle.isNotEmpty)
                                  Text(
                                    c.subtitle,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.white.withAlpha(230),
                                      fontSize: subtitleFontSize,
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
            ),
          ),
        );
      },
    );
  }
}