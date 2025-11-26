import 'package:equatable/equatable.dart';
import 'package:mango/core/domain/entities/comic/comic.dart';

abstract class ComicDetailRouteState extends Equatable {
  const ComicDetailRouteState();

  @override
  List<Object> get props => [];
}

// State saat sedang memuat (UI akan menampilkan loading spinner)
class ComicDetailRouteLoading extends ComicDetailRouteState {}

// State saat Gagal (UI akan menampilkan pesan error)
class ComicDetailRouteError extends ComicDetailRouteState {
  final String message;

  const ComicDetailRouteError(this.message);

  @override
  List<Object> get props => [message];
}

// State saat Sukses (UI akan menampilkan ComicDetailScreen)
class ComicDetailRouteSuccess extends ComicDetailRouteState {
  final Comic comic;

  const ComicDetailRouteSuccess(this.comic);

  @override
  List<Object> get props => [comic];
}
