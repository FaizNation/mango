part of 'home_cubit.dart';

enum HomeTab { all, manga, manhwa, manhua }
enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  final HomeStatus status;
  final List<ComicEntity> comics;
  final HomeTab selectedTab;
  final String? errorMessage;
  final int currentPage;
  final bool hasReachedMax;
  final String greeting;
  final String time;

  const HomeState({
    this.status = HomeStatus.initial,
    this.comics = const [],
    this.selectedTab = HomeTab.all,
    this.errorMessage,
    this.currentPage = 1,
    this.hasReachedMax = false,
    this.greeting = '',
    this.time = '',
  });

  HomeState copyWith({
    HomeStatus? status,
    List<ComicEntity>? comics,
    HomeTab? selectedTab,
    String? errorMessage,
    int? currentPage,
    bool? hasReachedMax,
    String? greeting,
    String? time,
  }) {
    return HomeState(
      status: status ?? this.status,
      comics: comics ?? this.comics,
      selectedTab: selectedTab ?? this.selectedTab,
      errorMessage: errorMessage,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      greeting: greeting ?? this.greeting,
      time: time ?? this.time,
    );
  }

  @override
  List<Object?> get props => [
        status,
        comics,
        selectedTab,
        errorMessage,
        currentPage,
        hasReachedMax,
        greeting,
        time,
      ];
}
