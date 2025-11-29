import 'package:mango/core/error/failure.dart';
import 'package:mango/features/history/domain/entities/history_entry_entity.dart';
import 'package:mango/features/home/domain/entities/comic_entity.dart';

abstract class HistoryRepository {
  /// Throws a [ServerFailure] if an error occurs.
  Stream<List<HistoryEntryEntity>> getHistory();

  /// Throws a [ServerFailure] if an error occurs.
  Future<void> addHistoryEntry(ComicEntity comic);

  /// Throws a [ServerFailure] if an error occurs.
  Future<void> deleteHistoryEntry(String id);

  /// Throws a [ServerFailure] if an error occurs.
  Future<void> clearAllHistory();
}
