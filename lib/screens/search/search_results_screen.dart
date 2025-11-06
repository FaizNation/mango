import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubits/search/search_cubit.dart';
import '../../cubits/search/search_state.dart';
import '../../widgets/manga_widget.dart';

class SearchResultsScreen extends StatelessWidget {
  final String query;

  const SearchResultsScreen({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchCubit()..search(query, reset: true),
      child: _SearchResultsView(query: query),
    );
  }
}

class _SearchResultsView extends StatelessWidget {
  final String query;

  const _SearchResultsView({required this.query});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Results for: $query')),
      body: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          if (state.error != null) {
            return Center(
              child: Text(
                state.error!,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (state.isLoading && state.results.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.results.isEmpty) {
            return const Center(child: Text('No results found'));
          }

          return ComicListView(
            comics: state.results,
            isLoading: state.isLoading,
            onLoadMore: () => context.read<SearchCubit>().loadMore(),
            error: state.error,
          );
        },
      ),
    );
  }
}
