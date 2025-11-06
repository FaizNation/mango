import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/comic/comic.dart';
import '../../services/api_service.dart' as service;
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final service.ApiService _apiService = service.ApiService();
  Timer? _timer;

  HomeCubit() : super(const HomeState()) {
    _startTimer();
    loadInitialData();
  }

  void _startTimer() {
    _updateGreeting(); // Initial update
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateGreeting();
    });
  }

  void _updateGreeting() {
    final now = DateTime.now();
    final hour = now.hour;

    String newGreeting;
    if (hour >= 5 && hour < 12) {
      newGreeting = "Ohayō!";
    } else if (hour >= 12 && hour < 15) {
      newGreeting = "Konnichiwa!";
    } else if (hour >= 15 && hour < 18) {
      newGreeting = "Yūgata!";
    } else {
      newGreeting = "Konbanwa!";
    }

    final newTime =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

    emit(state.copyWith(greeting: newGreeting, time: newTime));
  }

  Future<void> loadInitialData() async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      // load general list and specific types
      final all = await _apiService.getComics(page: state.currentPage);
      final mangaList = await _apiService.getComicsByType('manga');
      final manhwaList = await _apiService.getComicsByType('manhwa');
      final manhuaList = await _apiService.getComicsByType('manhua');

      emit(
        state.copyWith(
          allManga: all,
          manga: mangaList,
          manhwa: manhwaList,
          manhua: manhuaList,
          isLoading: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(error: 'Failed to load comics: $e', isLoading: false),
      );
    }
  }

  Future<void> loadMoreManga() async {
    if (state.isLoading) return;
    emit(state.copyWith(isLoading: true));
    try {
      final nextPage = state.currentPage + 1;
      List<Comic> more = [];
      switch (state.selectedTab) {
        case HomeTab.all:
          more = await _apiService.getComics(page: nextPage);
          emit(
            state.copyWith(
              allManga: [...state.allManga, ...more],
              currentPage: nextPage,
              isLoading: false,
            ),
          );
          break;
        case HomeTab.manga:
          more = await _apiService.getComicsByType('manga', page: nextPage);
          emit(
            state.copyWith(
              manga: [...state.manga, ...more],
              currentPage: nextPage,
              isLoading: false,
            ),
          );
          break;
        case HomeTab.manhwa:
          more = await _apiService.getComicsByType('manhwa', page: nextPage);
          emit(
            state.copyWith(
              manhwa: [...state.manhwa, ...more],
              currentPage: nextPage,
              isLoading: false,
            ),
          );
          break;
        case HomeTab.manhua:
          more = await _apiService.getComicsByType('manhua', page: nextPage);
          emit(
            state.copyWith(
              manhua: [...state.manhua, ...more],
              currentPage: nextPage,
              isLoading: false,
            ),
          );
          break;
      }
    } catch (e) {
      emit(
        state.copyWith(
          error: 'Failed to load more manga: $e',
          isLoading: false,
        ),
      );
    }
  }

  void selectTab(HomeTab tab) {
    emit(state.copyWith(selectedTab: tab));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
