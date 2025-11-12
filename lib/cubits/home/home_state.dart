import 'package:equatable/equatable.dart';
import '../../models/comic/comic.dart';

enum HomeTab { all, manga, manhwa, manhua }

class HomeState extends Equatable {
  // Properti yang sudah ada
  final List<Comic> allManga;
  final List<Comic> manga;
  final List<Comic> manhwa;
  final List<Comic> manhua;
  final bool isLoading; // Ini untuk loading tab
  final String? error;
  final HomeTab selectedTab;
  final String greeting;
  final String time;
  final int currentPage;

  // --- PROPERTI BARU UNTUK SEARCH ---
  final String searchQuery;
  final List<Comic> searchResults;
  final bool isSearching; // Ini untuk loading search
  final int searchCurrentPage;
  final bool searchHasMore;

  const HomeState({
    this.allManga = const [],
    this.manga = const [],
    this.manhwa = const [],
    this.manhua = const [],
    this.isLoading = false,
    this.error,
    this.selectedTab = HomeTab.all,
    this.greeting = '',
    this.time = '',
    this.currentPage = 1,
    // --- Inisialisasi properti baru ---
    this.searchQuery = '',
    this.searchResults = const [],
    this.isSearching = false,
    this.searchCurrentPage = 1,
    this.searchHasMore = true,
  });

  // Helper getter untuk UI
  bool get isInSearchMode => searchQuery.isNotEmpty;

  HomeState copyWith({
    List<Comic>? allManga,
    List<Comic>? manga,
    List<Comic>? manhwa,
    List<Comic>? manhua,
    bool? isLoading,
    String? error,
    HomeTab? selectedTab,
    String? greeting,
    String? time,
    int? currentPage,
    // --- Tambahkan properti baru ke copyWith ---
    String? searchQuery,
    List<Comic>? searchResults,
    bool? isSearching,
    int? searchCurrentPage,
    bool? searchHasMore,
  }) {
    // Setel 'error' ke null jika ada aksi lain
    final bool shouldClearError = isLoading != null ||
        searchQuery != null ||
        searchResults != null ||
        isSearching != null;

    return HomeState(
      allManga: allManga ?? this.allManga,
      manga: manga ?? this.manga,
      manhwa: manhwa ?? this.manhwa,
      manhua: manhua ?? this.manhua,
      isLoading: isLoading ?? this.isLoading,
      error: shouldClearError ? null : (error ?? this.error),
      selectedTab: selectedTab ?? this.selectedTab,
      greeting: greeting ?? this.greeting,
      time: time ?? this.time,
      currentPage: currentPage ?? this.currentPage,
      // --- Terapkan properti baru ---
      searchQuery: searchQuery ?? this.searchQuery,
      searchResults: searchResults ?? this.searchResults,
      isSearching: isSearching ?? this.isSearching,
      searchCurrentPage: searchCurrentPage ?? this.searchCurrentPage,
      searchHasMore: searchHasMore ?? this.searchHasMore,
    );
  }

  @override
  List<Object?> get props => [
        allManga,
        manga,
        manhwa,
        manhua,
        isLoading,
        error,
        selectedTab,
        greeting,
        time,
        currentPage,
        // --- Tambahkan properti baru ke props ---
        searchQuery,
        searchResults,
        isSearching,
        searchCurrentPage,
        searchHasMore,
      ];
}