import 'package:flutter/material.dart';
import '../models/comic.dart';

class FavoritesProvider extends ChangeNotifier {
  final List<Comic> _favorites = [];

  List<Comic> get favorites => List.unmodifiable(_favorites);

  bool isFavorite(Comic comic) {
    return _favorites.any((element) => element.id == comic.id);
  }

  void toggleFavorite(Comic comic) {
    if (isFavorite(comic)) {
      _favorites.removeWhere((element) => element.id == comic.id);
    } else {
      _favorites.add(comic);
    }
    notifyListeners();
  }
}
