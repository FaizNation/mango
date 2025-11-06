import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/api_service.dart' as service;
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final service.ApiService _apiService = service.ApiService();

  SearchCubit() : super(const SearchState());

  Future<void> search(String query, {bool reset = false}) async {
    if (state.isLoading) return;
    if (reset) {
      emit(SearchState(query: query));
    }
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final results = await _apiService.searchComics(
        query,
        page: state.currentPage,
      );

      emit(
        state.copyWith(
          results: reset ? results : [...state.results, ...results],
          currentPage: state.currentPage + 1,
          isLoading: false,
          hasMore: results.length >= 20,
        ),
      );
    } catch (e) {
      emit(state.copyWith(error: 'Search failed: $e', isLoading: false));
    }
  }

  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore) return;
    await search(state.query);
  }
}
