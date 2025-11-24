import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mango/core/error/failure.dart';
import 'package:mango/core/usecase/usecase.dart';
import 'package:mango/features/favorites/domain/usecases/add_favorite.dart';
import 'package:mango/features/favorites/domain/usecases/get_favorites.dart';
import 'package:mango/features/favorites/domain/usecases/remove_favorite.dart';
import 'package:mango/features/home/domain/entities/comic_entity.dart';

part 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final GetFavorites _getFavorites;
  final AddFavorite _addFavorite;
  final RemoveFavorite _removeFavorite;
  StreamSubscription? _favoritesSubscription;

  FavoritesCubit({
    required GetFavorites getFavorites,
    required AddFavorite addFavorite,
    required RemoveFavorite removeFavorite,
  })  : _getFavorites = getFavorites,
        _addFavorite = addFavorite,
        _removeFavorite = removeFavorite,
        super(const FavoritesState()) {
    _monitorFavorites();
  }

  void _monitorFavorites() {
    emit(state.copyWith(status: FavoritesStatus.loading));
    _favoritesSubscription = _getFavorites(NoParams()).listen((favorites) {
      emit(state.copyWith(
        status: FavoritesStatus.success,
        favorites: favorites,
      ));
    }, onError: (error) {
      if (error is ServerFailure) {
        emit(state.copyWith(status: FavoritesStatus.failure, errorMessage: error.message));
      } else {
        emit(state.copyWith(status: FavoritesStatus.failure, errorMessage: 'An unknown error occurred'));
      }
    });
  }

  bool isFavorite(String comicId) {
    return state.favorites.any((comic) => comic.id == comicId);
  }

  Future<void> toggleFavorite(ComicEntity comic) async {
    try {
      if (isFavorite(comic.id)) {
        await _removeFavorite(RemoveFavoriteParams(comicId: comic.id));
      } else {
        await _addFavorite(AddFavoriteParams(comic: comic));
      }
    } on ServerFailure catch (e) {
      // The stream will eventually report the new state, so we don't need to emit a failure state here
      // for the main list. A transient snackbar could be shown in the UI.
      print('Failed to toggle favorite: ${e.message}');
    }
  }

  @override
  Future<void> close() {
    _favoritesSubscription?.cancel();
    return super.close();
  }
}
