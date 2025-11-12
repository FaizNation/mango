
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/comic/comic.dart';
import '../../services/api_service.dart' as service;
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final service.ApiService _apiService = service.ApiService();
  Timer? _greetingTimer; // Diganti dari _timer
  Timer? _searchDebounce; // Timer baru untuk debouncer

  HomeCubit() : super(const HomeState()) {
    _startTimer();
    loadInitialData();
  }

  void _startTimer() {
    _updateGreeting(); // Initial update
    _greetingTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateGreeting();
    });
  }

  void _updateGreeting() {
    // ... (Fungsi _updateGreeting Anda tidak berubah, biarkan saja)
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
    // ... (Fungsi loadInitialData Anda tidak berubah)
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
    // ... (Fungsi loadMoreManga Anda tidak berubah)
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

  // --- LOGIKA PENCARIAN BARU DIMULAI DI SINI ---

  // Dipanggil dari UI setiap kali teks berubah
  void onSearchQueryChanged(String query) {
    // Batalkan timer sebelumnya jika ada
    _searchDebounce?.cancel();

    // Simpan kueri di state agar UI bisa update
    emit(state.copyWith(searchQuery: query));

    if (query.isEmpty) {
      // Jika kueri kosong, bersihkan hasil pencarian & setop loading
      emit(state.copyWith(
        searchResults: [],
        isSearching: false,
        searchCurrentPage: 1,
        searchHasMore: true,
      ));
      return;
    }

    // Tampilkan loading spinner
    emit(state.copyWith(isSearching: true));

    // Mulai timer baru. Pencarian hanya akan dieksekusi setelah 500ms
    // pengguna berhenti mengetik.
    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      _performSearch(query, reset: true);
    });
  }

  // Fungsi internal untuk mengambil data dari API
  Future<void> _performSearch(String query, {bool reset = false}) async {
    // Jika kueri kosong, jangan lakukan apa-apa
    if (query.isEmpty) {
      emit(state.copyWith(
        searchResults: [],
        isSearching: false,
        searchCurrentPage: 1,
        searchHasMore: true,
        searchQuery: '', // Pastikan kueri juga bersih
      ));
      return;
    }

    // Tentukan halaman yang akan diambil
    final pageToFetch = reset ? 1 : state.searchCurrentPage;

    // Set state ke loading (meskipun sudah diset di onSearchQueryChanged)
    emit(state.copyWith(isSearching: true, error: null));

    try {
      final results = await _apiService.searchComics(
        query,
        page: pageToFetch,
      );

      emit(state.copyWith(
        // Jika 'reset' true, ganti hasil. Jika false, tambahkan ke hasil.
        searchResults: reset ? results : [...state.searchResults, ...results],
        searchCurrentPage: pageToFetch + 1,
        isSearching: false,
        searchHasMore: results.length >= 20, // Asumsi 20 item per halaman
      ));
    } catch (e) {
      emit(state.copyWith(error: 'Search failed: $e', isSearching: false));
    }
  }

  // Dipanggil oleh UI (ComicListView) saat scroll ke bawah
  Future<void> loadMoreSearch() async {
    if (state.isSearching || !state.searchHasMore) return;
    // Panggil _performSearch dengan kueri yang ada di state
    _performSearch(state.searchQuery, reset: false);
  }

  // Dipanggil oleh tombol 'clear' (X) di TextField
  void clearSearch() {
    _searchDebounce?.cancel();
    emit(state.copyWith(
      searchQuery: '',
      searchResults: [],
      isSearching: false,
      searchCurrentPage: 1,
      searchHasMore: true,
      error: null,
    ));
  }
  // --- AKHIR LOGIKA PENCARIAN BARU ---

  @override
  Future<void> close() {
    _greetingTimer?.cancel(); // Timer lama
    _searchDebounce?.cancel(); // Timer baru
    return super.close();
  }
}