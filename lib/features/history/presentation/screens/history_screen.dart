import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mango/features/history/presentation/cubit/history_cubit.dart';
import 'package:mango/features/history/presentation/widgets/history_list_view.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F2FF),
      appBar: AppBar(
        title: const Text('My History'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFE6F2FF),
        actions: [
          BlocBuilder<HistoryCubit, HistoryState>(
            builder: (context, state) {
              if (state.history.isEmpty) {
                return const SizedBox.shrink();
              }
              return IconButton(
                icon: const Icon(Icons.delete_forever),
                tooltip: 'Clear all history',
                onPressed: () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Clear history'),
                      content: const Text('Are you sure you want to clear all history?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(true),
                          child: const Text('Clear'),
                        ),
                      ],
                    ),
                  );

                  if (confirmed == true) {
                    // ignore: use_build_context_synchronously
                    context.read<HistoryCubit>().clearAllHistory();
                  }
                },
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<HistoryCubit, HistoryState>(
        builder: (context, state) {
          if (state.status == HistoryStatus.loading && state.history.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (state.status == HistoryStatus.failure) {
            return Center(child: Text(state.errorMessage ?? 'Failed to load history'));
          }
          
          if (state.history.isEmpty) {
            return const Center(
              child: Text(
                'No history yet!',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return HistoryListView(
            entries: state.history,
            onDelete: (id) {
              context.read<HistoryCubit>().deleteHistoryEntry(id);
            },
          );
        },
      ),
    );
  }
}
