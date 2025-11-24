import 'package:equatable/equatable.dart';
import 'package:mango/core/usecase/usecase.dart';
import 'package:mango/features/home/domain/entities/comic_entity.dart';
import 'package:mango/features/home/domain/repositories/home_repository.dart';

class GetComics extends UseCase<List<ComicEntity>, GetComicsParams> {
  final HomeRepository repository;

  GetComics(this.repository);

  @override
  Future<List<ComicEntity>> call(GetComicsParams params) async {
    return await repository.getComics(page: params.page);
  }
}

class GetComicsParams extends Equatable {
  final int page;

  const GetComicsParams({this.page = 1});

  @override
  List<Object> get props => [page];
}
