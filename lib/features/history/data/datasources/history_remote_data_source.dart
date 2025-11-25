import 'package:mango/features/history/data/models/history_entry_model.dart';
import 'package:mango/features/home/domain/entities/comic_entity.dart';

abstract class HistoryRemoteDataSource {
  Stream<List<HistoryEntryModel>> getHistory();
  Future<void> addHistoryEntry(ComicEntity comic);
  Future<void> deleteHistoryEntry(String id);
  Future<void> clearAllHistory();
}
