import 'package:equatable/equatable.dart';
import '../../models/chapter.dart';

// Kelas dasar untuk state
abstract class ComicDetailState extends Equatable {
  const ComicDetailState();

  @override
  List<Object> get props => [];
}

// State awal, belum ada aksi
class ComicDetailInitial extends ComicDetailState {}

// State ketika sedang memuat data chapter
class ComicDetailLoading extends ComicDetailState {}

// State ketika data chapter berhasil dimuat
class ComicDetailLoaded extends ComicDetailState {
  final List<Chapter> chapters;

  const ComicDetailLoaded(this.chapters);

  @override
  List<Object> get props => [chapters];
}

// State ketika terjadi error saat memuat
class ComicDetailError extends ComicDetailState {
  final String message;

  const ComicDetailError(this.message);

  @override
  List<Object> get props => [message];
}