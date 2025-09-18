class Chapter {
  final String id;
  final String title;
  final String comicId;
  final List<String> images;
  final DateTime uploadDate;
  final int chapterNumber;

  const Chapter({
    required this.id,
    required this.title,
    required this.comicId,
    required this.images,
    required this.uploadDate,
    required this.chapterNumber,
  });
}
