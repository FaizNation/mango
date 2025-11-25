import 'package:equatable/equatable.dart';
import 'package:mango/core/usecase/usecase.dart';
import 'package:mango/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:mango/features/home/domain/entities/comic_entity.dart';

class AddFavorite extends UseCase<void, AddFavoriteParams> {
  final FavoritesRepository repository;

  AddFavorite(this.repository);

  @override
  Future<void> call(AddFavoriteParams params) async {
    return await repository.addFavorite(params.comic);
  }
}

class AddFavoriteParams extends Equatable {
  final ComicEntity comic;

  const AddFavoriteParams({required this.comic});

  @override
  List<Object> get props => [comic];
}
