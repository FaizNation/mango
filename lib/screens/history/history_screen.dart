import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mango/providers/history_provider.dart';
import 'package:mango/widgets/history_list_view.dart';
// navigation and model resolution handled inside HistoryListView
import 'package:provider/provider.dart';

// history entry model used by the list widget

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFE6F2FF),
      appBar: AppBar(
        title: const Text('My History'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFE6F2FF),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            tooltip: 'Clear all history',
            onPressed: user == null
                ? null
                : () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Clear history'),
                        content: const Text(
                          'Are you sure you want to clear all history?',
                        ),
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

                    if (confirmed != true) return;
                    // ignore: use_build_context_synchronously
                    await context.read<HistoryProvider>().clearAll();
                  },
          ),
        ],
      ),
      body: Center(
        child: Container(
          // On wider screens, this constrains the content to a max width of 700.
          // On smaller screens (less than 700), this has no effect.
          constraints: const BoxConstraints(maxWidth: 700),
          child: Consumer<HistoryProvider>(
            builder: (context, provider, child) {
              if (provider.entries.isEmpty) {
                return const Center(
                  child:
                      Text('No history yet!', style: TextStyle(fontSize: 18)),
                );
              }
              return HistoryListView(entries: provider.entries);
            },
          ),
        ),
      ),
    );
  }
}
