import 'package:mango/core/error/failure.dart';
import 'package:mango/features/history/domain/entities/history_entry_entity.dart';
import 'package:mango/features/home/domain/entities/comic_entity.dart';

abstract class HistoryRepository {
  /// Returns a stream of the user's reading history.
  /// Throws a [ServerFailure] if an error occurs.
  Stream<List<HistoryEntryEntity>> getHistory();

  /// Adds a comic to the reading history.
  /// Throws a [ServerFailure] if an error occurs.
  Future<void> addHistoryEntry(ComicEntity comic);

  /// Removes a specific entry from the history by its [id].
  /// Throws a [ServerFailure] if an error occurs.
  Future<void> deleteHistoryEntry(String id);

  /// Removes all entries from the history.
  /// Throws a [ServerFailure] if an error occurs.
  Future<void> clearAllHistory();
}
