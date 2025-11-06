import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mango/widgets/history_widget.dart';
import 'package:provider/provider.dart';
import '../../providers/history_provider.dart';


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
          constraints: const BoxConstraints(maxWidth: 700),
          child: Consumer<HistoryProvider>(
            builder: (context, provider, child) {
              if (provider.entries.isEmpty) {
                return const Center(
                  child: Text(
                    'No history yet!',
                    style: TextStyle(fontSize: 18),
                  ),
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
