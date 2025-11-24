import 'package:equatable/equatable.dart';
import 'package:mango/core/usecase/usecase.dart';
import 'package:mango/features/history/domain/repositories/history_repository.dart';

class DeleteHistoryEntry extends UseCase<void, DeleteHistoryEntryParams> {
  final HistoryRepository repository;

  DeleteHistoryEntry(this.repository);

  @override
  Future<void> call(DeleteHistoryEntryParams params) async {
    return await repository.deleteHistoryEntry(params.id);
  }
}

class DeleteHistoryEntryParams extends Equatable {
  final String id;

  const DeleteHistoryEntryParams({required this.id});

  @override
  List<Object> get props => [id];
}
