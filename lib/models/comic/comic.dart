class Comic {
  final String _id;
  final String _title;
  final String _author;
  final String _description;
  final String _coverImage;
  double _rating;
  final List<String> _genres;
  String _status;
  int _chapters;
  final String _releaseYear;

  Comic({
    required String id,
    required String title,
    required String author,
    required String description,
    required String coverImage,
    required double rating,
    required List<String> genres,
    String status = 'Ongoing',
    int chapters = 0,
    String releaseYear = '',
  }) : _id = id,
       _title = title,
       _author = author,
       _description = description,
       _coverImage = coverImage,
       _rating = rating,
       _genres = genres,
       _status = status,
       _chapters = chapters,
       _releaseYear = releaseYear;

  String get id => _id;
  String get title => _title;
  String get author => _author;
  String get description => _description;
  String get coverImage => _coverImage;
  double get rating => _rating;
  List<String> get genres => List.unmodifiable(_genres);
  // ignore: unnecessary_getters_setters
  String get status => _status;
  int get chapters => _chapters;
  String get releaseYear => _releaseYear;

  set rating(double newRating) {
    if (newRating >= 0 && newRating <= 5) {
      _rating = newRating;
    }
  }

  set status(String newStatus) {
    _status = newStatus;
  }

  set chapters(int newChapters) {
    if (newChapters >= 0) {
      _chapters = newChapters;
    }
  }

  Map<String, dynamic> getAdditionalInfo() {
    return {
      'Status': _status,
      'Chapters': _chapters > 0 ? '$_chapters chapters' : 'N/A',
      'Release Year': _releaseYear.isNotEmpty ? _releaseYear : 'N/A',
    };
  }

  String getType() => 'Comic';
}
