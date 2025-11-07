import 'package:flutter/material.dart';
import '../../services/api_service.dart' as service;
import '../../models/chapter.dart';
import '../../screens/chapter_detail_screen.dart';

class ChapterRoute extends StatefulWidget {
  final String comicId;
  final String chapterId;

  const ChapterRoute({
    super.key,
    required this.comicId,
    required this.chapterId,
  });

  @override
  State<ChapterRoute> createState() => _ChapterRouteState();
}

class _ChapterRouteState extends State<ChapterRoute> {
  final service.ApiService _api = service.ApiService();
  List<Chapter> _chapters = [];
  Chapter? _chapter;
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
      final list = await _api.getChapters(widget.comicId);
      _chapters = list;
      try {
        _chapter = _chapters.firstWhere((c) => c.id == widget.chapterId);
      } catch (_) {
        if (_chapters.isNotEmpty) {
          _chapter = _chapters[0];
        } else {
          _chapter = null;
        }
      }
      if (_chapter == null) _error = 'Chapter not found';
    } catch (e) {
      _error = 'Failed to load chapters: $e';
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Chapter')),
        body: Center(child: Text(_error!)),
      );
    }
    if (_chapter == null) {
      return const Scaffold(body: Center(child: Text('Chapter not found')));
    }

    return ChapterDetailScreen(chapter: _chapter!, allChapters: _chapters);
  }
}
