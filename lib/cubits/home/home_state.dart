import 'package:equatable/equatable.dart';
import '../../models/comic/comic.dart';

enum HomeTab { all, manga, manhwa, manhua }

class HomeState extends Equatable {
  final List<Comic> allManga;
  final List<Comic> manga;
  final List<Comic> manhwa;
  final List<Comic> manhua;
  final bool isLoading;
  final String? error;
  final HomeTab selectedTab;
  final String greeting;
  final String time;
  final int currentPage;

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
  });

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
  }) {
    return HomeState(
      allManga: allManga ?? this.allManga,
      manga: manga ?? this.manga,
      manhwa: manhwa ?? this.manhwa,
      manhua: manhua ?? this.manhua,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      selectedTab: selectedTab ?? this.selectedTab,
      greeting: greeting ?? this.greeting,
      time: time ?? this.time,
      currentPage: currentPage ?? this.currentPage,
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
  ];
}
