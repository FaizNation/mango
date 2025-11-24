import 'package:equatable/equatable.dart';
import 'package:mango/core/usecase/usecase.dart';
import 'package:mango/features/favorites/domain/repositories/favorites_repository.dart';

class RemoveFavorite extends UseCase<void, RemoveFavoriteParams> {
  final FavoritesRepository repository;

  RemoveFavorite(this.repository);

  @override
  Future<void> call(RemoveFavoriteParams params) async {
    return await repository.removeFavorite(params.comicId);
  }
}

class RemoveFavoriteParams extends Equatable {
  final String comicId;

  const RemoveFavoriteParams({required this.comicId});

  @override
  List<Object> get props => [comicId];
}
