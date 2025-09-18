import '../models/chapter.dart';

Map<String, List<Chapter>> allComicChapters = {
  'op001': _getOnePieceChapters(),
  'ds001': _getDemonSlayerChapters(),
  'jjk001': _getJujutsuKaisenChapters(),
};

List<Chapter> _getJujutsuKaisenChapters() {
  return [
    Chapter(
      id: 'jjk_ch1',
      title: 'Ryomen Sukuna',
      comicId: 'jjk001',
      chapterNumber: 1,
      uploadDate: DateTime.now().subtract(const Duration(days: 28)),
      images: [
        'https://via.placeholder.com/800x1200.png?text=Ryomen+Sukuna+Page+1',
        'https://via.placeholder.com/800x1200.png?text=Ryomen+Sukuna+Page+2',
        'https://via.placeholder.com/800x1200.png?text=Ryomen+Sukuna+Page+3',
      ],
    ),
    Chapter(
      id: 'jjk_ch2',
      title: 'For Myself',
      comicId: 'jjk001',
      chapterNumber: 2,
      uploadDate: DateTime.now().subtract(const Duration(days: 21)),
      images: [
        'https://via.placeholder.com/800x1200.png?text=For+Myself+Page+1',
        'https://via.placeholder.com/800x1200.png?text=For+Myself+Page+2',
        'https://via.placeholder.com/800x1200.png?text=For+Myself+Page+3',
      ],
    ),
    Chapter(
      id: 'jjk_ch3',
      title: 'Girl of Steel',
      comicId: 'jjk001',
      chapterNumber: 3,
      uploadDate: DateTime.now().subtract(const Duration(days: 14)),
      images: [
        'https://via.placeholder.com/800x1200.png?text=Girl+of+Steel+Page+1',
        'https://via.placeholder.com/800x1200.png?text=Girl+of+Steel+Page+2',
        'https://via.placeholder.com/800x1200.png?text=Girl+of+Steel+Page+3',
      ],
    ),
  ];
}

List<Chapter> getSampleChapters(String comicId) {
  return allComicChapters[comicId] ?? [];
}

List<Chapter> _getDemonSlayerChapters() {
  return [
    Chapter(
      id: 'ds_ch1',
      title: 'Cruelty',
      comicId: 'ds001',
      chapterNumber: 1,
      uploadDate: DateTime.now().subtract(const Duration(days: 25)),
      images: [
        'https://img.komiku.org/wp-content/uploads/40508-2.jpg',
        'https://img.komiku.org/wp-content/uploads/40508-2.jpg',
        'https://img.komiku.org/wp-content/uploads/40508-2.jpg',
      ],
    ),
    Chapter(
      id: 'ds_ch2',
      title: 'Trainer Sakonji Urokodaki',
      comicId: 'ds001',
      chapterNumber: 2,
      uploadDate: DateTime.now().subtract(const Duration(days: 18)),
      images: [
        'https://img.komiku.org/wp-content/uploads/40508-2.jpg',
        'https://img.komiku.org/wp-content/uploads/40508-2.jpg',
        'https://img.komiku.org/wp-content/uploads/40508-2.jpg',
      ],
    ),
    Chapter(
      id: 'ds_ch3',
      title: 'Final Selection',
      comicId: 'ds001',
      chapterNumber: 3,
      uploadDate: DateTime.now().subtract(const Duration(days: 11)),
      images: [
        'https://via.placeholder.com/800x1200.png?text=Final+Selection+Page+1',
        'https://via.placeholder.com/800x1200.png?text=Final+Selection+Page+2',
        'https://via.placeholder.com/800x1200.png?text=Final+Selection+Page+3',
      ],
    ),
  ];
}

List<Chapter> _getOnePieceChapters() {
  return [
    Chapter(
      id: 'op_ch1',
      title: 'Romance Dawn',
      comicId: 'op001',
      chapterNumber: 1,
      uploadDate: DateTime.now().subtract(const Duration(days: 30)),
      images: [
        'https://via.placeholder.com/800x1200.png?text=Romance+Dawn+Scene+1',
        'https://via.placeholder.com/800x1200.png?text=Romance+Dawn+Scene+2',
        'https://via.placeholder.com/800x1200.png?text=Romance+Dawn+Scene+3',
        'https://via.placeholder.com/800x1200.png?text=Romance+Dawn+Scene+4',
        'https://via.placeholder.com/800x1200.png?text=Romance+Dawn+Scene+5',
      ],
    ),
    Chapter(
      id: 'ch2',
      title: 'The Adventure Begins',
      comicId: 'op001',
      chapterNumber: 2,
      uploadDate: DateTime.now().subtract(const Duration(days: 23)),
      images: [
        'https://via.placeholder.com/800x1200.png?text=Chapter+2+Page+1',
        'https://via.placeholder.com/800x1200.png?text=Chapter+2+Page+2',
        'https://via.placeholder.com/800x1200.png?text=Chapter+2+Page+3',
      ],
    ),
    Chapter(
      id: 'ch3',
      title: 'New Challenges',
      comicId: 'op001',
      chapterNumber: 3,
      uploadDate: DateTime.now().subtract(const Duration(days: 16)),
      images: [
        'https://via.placeholder.com/800x1200.png?text=Chapter+3+Page+1',
        'https://via.placeholder.com/800x1200.png?text=Chapter+3+Page+2',
        'https://via.placeholder.com/800x1200.png?text=Chapter+3+Page+3',
      ],
    ),
    Chapter(
      id: 'ch4',
      title: 'Rising Action',
      comicId: 'op001',
      chapterNumber: 4,
      uploadDate: DateTime.now().subtract(const Duration(days: 9)),
      images: [
        'https://via.placeholder.com/800x1200.png?text=Chapter+4+Page+1',
        'https://via.placeholder.com/800x1200.png?text=Chapter+4+Page+2',
        'https://via.placeholder.com/800x1200.png?text=Chapter+4+Page+3',
      ],
    ),
    Chapter(
      id: 'ch5',
      title: 'The Climax',
      comicId: 'op001',
      chapterNumber: 5,
      uploadDate: DateTime.now().subtract(const Duration(days: 2)),
      images: [
        'https://via.placeholder.com/800x1200.png?text=Chapter+5+Page+1',
        'https://via.placeholder.com/800x1200.png?text=Chapter+5+Page+2',
        'https://via.placeholder.com/800x1200.png?text=Chapter+5+Page+3',
      ],
    ),
  ];
}
