import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mango/core/error/failure.dart';
import 'package:mango/features/home/domain/entities/comic_entity.dart';
import 'package:mango/features/home/domain/usecases/get_comics.dart';
import 'package:mango/features/home/domain/usecases/get_comics_by_type.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetComics _getComics;
  final GetComicsByType _getComicsByType;
  Timer? _timer;

  HomeCubit({
    required GetComics getComics,
    required GetComicsByType getComicsByType,
  }) : _getComics = getComics,
       _getComicsByType = getComicsByType,
       super(const HomeState()) {
    _startTimer();
    loadComics();
  }

  void _startTimer() {
    _updateGreeting();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _updateGreeting(),
    );
  }

  void _updateGreeting() {
    final now = DateTime.now();
    final hour = now.hour;
    String newGreeting;
    if (hour >= 5 && hour < 12)
      newGreeting = "Ohayō!";
    else if (hour >= 12 && hour < 15)
      newGreeting = "Konnichiwa!";
    else if (hour >= 15 && hour < 18)
      newGreeting = "Yūgata!";
    else
      newGreeting = "Konbanwa!";
    final newTime =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
    emit(state.copyWith(greeting: newGreeting, time: newTime));
  }

  Future<void> loadComics({bool isRefresh = false}) async {
    if (isRefresh) {
      emit(state.copyWith(comics: [], currentPage: 1, hasReachedMax: false));
    }

    if (state.status == HomeStatus.loading || state.hasReachedMax) return;

    emit(state.copyWith(status: HomeStatus.loading));

    try {
      final newComics = await _fetchComicsForTab(
        state.selectedTab,
        state.currentPage,
      );
      if (newComics.isEmpty) {
        emit(state.copyWith(status: HomeStatus.success, hasReachedMax: true));
      } else {
        emit(
          state.copyWith(
            status: HomeStatus.success,
            comics: List.of(state.comics)..addAll(newComics),
            currentPage: state.currentPage + 1,
          ),
        );
      }
    } on ServerFailure catch (e) {
      emit(state.copyWith(status: HomeStatus.failure, errorMessage: e.message));
    }
  }

  Future<List<ComicEntity>> _fetchComicsForTab(HomeTab tab, int page) {
    switch (tab) {
      case HomeTab.manga:
        return _getComicsByType(
          GetComicsByTypeParams(type: 'manga', page: page),
        );
      case HomeTab.manhwa:
        return _getComicsByType(
          GetComicsByTypeParams(type: 'manhwa', page: page),
        );
      case HomeTab.manhua:
        return _getComicsByType(
          GetComicsByTypeParams(type: 'manhua', page: page),
        );
      case HomeTab.all:
        return _getComics(GetComicsParams(page: page));
    }
  }

  void selectTab(HomeTab tab) {
    if (state.selectedTab == tab) return;
    emit(
      state.copyWith(
        selectedTab: tab,
        status: HomeStatus.initial,
        comics: [],
        currentPage: 1,
        hasReachedMax: false,
      ),
    );
    loadComics();
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
