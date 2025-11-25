import 'dart:async';

import 'package:mango/core/usecase/usecase.dart';
import 'package:mango/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:mango/features/home/domain/entities/comic_entity.dart';

class GetFavorites extends StreamUseCase<List<ComicEntity>, NoParams> {
  final FavoritesRepository repository;

  GetFavorites(this.repository);

  @override
  Stream<List<ComicEntity>> call(NoParams params) {
    return repository.getFavorites();
  }
}
