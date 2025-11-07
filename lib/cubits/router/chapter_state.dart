import 'package:equatable/equatable.dart';
import '../../models/chapter.dart';

abstract class ChapterRouteState extends Equatable {
  const ChapterRouteState();

  @override
  List<Object> get props => [];
}

// State saat sedang memuat (UI akan menampilkan loading spinner)
class ChapterRouteLoading extends ChapterRouteState {}

// State saat Gagal (UI akan menampilkan pesan error)
class ChapterRouteError extends ChapterRouteState {
  final String message;

  const ChapterRouteError(this.message);

  @override
  List<Object> get props => [message];
}

// State saat Sukses (UI akan menampilkan ChapterDetailScreen)
class ChapterRouteSuccess extends ChapterRouteState {
  final Chapter chapter;
  final List<Chapter> allChapters;

  const ChapterRouteSuccess({required this.chapter, required this.allChapters});

  @override
  List<Object> get props => [chapter, allChapters];
}