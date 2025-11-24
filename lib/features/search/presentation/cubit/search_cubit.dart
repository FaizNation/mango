import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mango/features/search/domain/usecases/search_comics.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchComics searchComics;

  SearchCubit({required this.searchComics}) : super(const SearchState());

  Future<void> search(String query, {bool reset = false}) async {
    if (state.isLoading) return;
    if (reset) {
      emit(SearchState(query: query));
    }
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final result = await searchComics(query, page: state.currentPage);
      
      result.fold(
        (failure) {
          emit(state.copyWith(error: 'Search failed: ${failure.message}', isLoading: false));
        },
        (comics) {
          emit(
            state.copyWith(
              results: reset ? comics : [...state.results, ...comics],
              currentPage: state.currentPage + 1,
              isLoading: false,
              hasMore: comics.length >= 20,
            ),
          );
        },
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
