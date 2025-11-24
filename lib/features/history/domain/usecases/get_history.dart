import 'dart:async';
import 'package:mango/core/usecase/usecase.dart';
import 'package:mango/features/history/domain/entities/history_entry_entity.dart';
import 'package:mango/features/history/domain/repositories/history_repository.dart';

class GetHistory extends StreamUseCase<List<HistoryEntryEntity>, NoParams> {
  final HistoryRepository repository;

  GetHistory(this.repository);

  @override
  Stream<List<HistoryEntryEntity>> call(NoParams params) {
    return repository.getHistory();
  }
}
