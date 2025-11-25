import 'package:equatable/equatable.dart';
import 'package:mango/core/usecase/usecase.dart';
import 'package:mango/features/home/domain/entities/comic_entity.dart';
import 'package:mango/features/home/domain/repositories/home_repository.dart';

class GetComicsByType extends UseCase<List<ComicEntity>, GetComicsByTypeParams> {
  final HomeRepository repository;

  GetComicsByType(this.repository);

  @override
  Future<List<ComicEntity>> call(GetComicsByTypeParams params) async {
    return await repository.getComicsByType(params.type, page: params.page);
  }
}

class GetComicsByTypeParams extends Equatable {
  final String type;
  final int page;

  const GetComicsByTypeParams({required this.type, this.page = 1});

  @override
  List<Object> get props => [type, page];
}
