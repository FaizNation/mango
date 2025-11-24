import 'package:equatable/equatable.dart';
import 'package:mango/core/usecase/usecase.dart';
import 'package:mango/features/history/domain/repositories/history_repository.dart';
import 'package:mango/features/home/domain/entities/comic_entity.dart';

class AddHistoryEntry extends UseCase<void, AddHistoryEntryParams> {
  final HistoryRepository repository;

  AddHistoryEntry(this.repository);

  @override
  Future<void> call(AddHistoryEntryParams params) async {
    return await repository.addHistoryEntry(params.comic);
  }
}

class AddHistoryEntryParams extends Equatable {
  final ComicEntity comic;

  const AddHistoryEntryParams({required this.comic});

  @override
  List<Object> get props => [comic];
}
