import 'package:mango/core/usecase/usecase.dart';
import 'package:mango/features/history/domain/repositories/history_repository.dart';

class ClearAllHistory extends UseCase<void, NoParams> {
  final HistoryRepository repository;

  ClearAllHistory(this.repository);

  @override
  Future<void> call(NoParams params) async {
    return await repository.clearAllHistory();
  }
}
