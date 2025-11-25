// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:mango/data/manga/manga_data.dart';
// import 'package:mango/models/comic/comic.dart';
// import 'package:mango/widgets/comic_detail_screen.dart';

// class MyCustomScrollBehavior extends MaterialScrollBehavior {
//   @override
//   Set<PointerDeviceKind> get dragDevices => {
//     ...super.dragDevices,
//     PointerDeviceKind.mouse,
//   };
// }

// Comic? findComicById(String id, BuildContext context) {
//   final manga = mangaList.where((comic) => comic.id == id).firstOrNull;
//   if (manga != null) return manga;

//   return null;
// }

// class NewComic {
//   final String title;
//   final String imageUrl;
//   final String subtitle;
//   final String id;

//   NewComic({
//     required this.title,
//     required this.imageUrl,
//     this.subtitle = '',
//     required this.id,
//   });
// }

// class ComicCarousel extends StatelessWidget {
//   final List<NewComic> comics;

//   const ComicCarousel({super.key, required this.comics});

//   @override
//   Widget build(BuildContext context) {
//     final w = MediaQuery.of(context).size.width;

//     return SizedBox(
//       height: w * 0.45,

//       child: ScrollConfiguration(
//         behavior: MyCustomScrollBehavior(),
//         child: ListView.separated(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           scrollDirection: Axis.horizontal,
//           itemCount: comics.length,
//           separatorBuilder: (_, __) => const SizedBox(width: 12),
//           itemBuilder: (context, index) {
//             final c = comics[index];
//             return GestureDetector(
//               onTap: () {
//                 final comic = findComicById(c.id, context);
//                 if (comic != null) {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => ComicDetailScreen(comic: comic),
//                     ),
//                   );
//                 }
//               },
//               child: SizedBox(
//                 width: 380,
//                 height: 130,
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(16),
//                   child: Stack(
//                     fit: StackFit.expand,
//                     children: [
//                       Image.asset(
//                         c.imageUrl,
//                         fit: BoxFit.cover,
//                         errorBuilder: (context, err, st) => Container(
//                           color: Colors.grey[300],
//                           child: const Center(
//                             child: Icon(Icons.image, size: 48),
//                           ),
//                         ),
//                       ),
//                       Positioned(
//                         left: 12,
//                         bottom: 12,
//                         right: 12,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Text(
//                               c.title,
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.w700,
//                               ),
//                             ),
//                             if (c.subtitle.isNotEmpty)
//                               Text(
//                                 c.subtitle,
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                                 style: TextStyle(
//                                   // ignore: deprecated_member_use
//                                   color: Colors.white.withOpacity(0.9),
//                                   fontSize: 13,
//                                 ),
//                               ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
