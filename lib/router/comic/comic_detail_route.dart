import 'package:flutter/material.dart';
import '../../models/comic/comic.dart';
import '../../services/api_service.dart' as service;
import '../../widgets/comic_detail_screen.dart';

class ComicDetailRoute extends StatefulWidget {
  final String comicId;

  const ComicDetailRoute({super.key, required this.comicId});

  @override
  State<ComicDetailRoute> createState() => _ComicDetailRouteState();
}

class _ComicDetailRouteState extends State<ComicDetailRoute> {
  final service.ApiService _api = service.ApiService();
  Comic? _comic;
  String? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final c = await _api.getComicDetail(widget.comicId);
      setState(() => _comic = c);
    } catch (e) {
      setState(() => _error = 'Failed to load comic: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Comic')),
        body: Center(child: Text(_error!)),
      );
    }
    if (_comic == null) {
      return const Scaffold(body: Center(child: Text('Comic not found')));
    }

    return ComicDetailScreen(comic: _comic!);
  }
}
