import 'package:equatable/equatable.dart';
import 'package:mango/features/home/domain/entities/comic_entity.dart';

class SearchState extends Equatable {
  final List<ComicEntity> results;
  final bool isLoading;
  final String? error;
  final int currentPage;
  final bool hasMore;
  final String query;

  const SearchState({
    this.results = const [],
    this.isLoading = false,
    this.error,
    this.currentPage = 1,
    this.hasMore = true,
    this.query = '',
  });

  SearchState copyWith({
    List<ComicEntity>? results,
    bool? isLoading,
    String? error,
    int? currentPage,
    bool? hasMore,
    String? query,
  }) {
    return SearchState(
      results: results ?? this.results,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      query: query ?? this.query,
    );
  }

  @override
  List<Object?> get props => [
    results,
    isLoading,
    error,
    currentPage,
    hasMore,
    query,
  ];
}
