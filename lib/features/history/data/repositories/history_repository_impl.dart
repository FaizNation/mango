import 'package:mango/core/error/exceptions.dart';
import 'package:mango/core/error/failure.dart';
import 'package:mango/features/history/data/datasources/history_remote_data_source.dart';
import 'package:mango/features/history/domain/entities/history_entry_entity.dart';
import 'package:mango/features/history/domain/repositories/history_repository.dart';
import 'package:mango/features/home/domain/entities/comic_entity.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  final HistoryRemoteDataSource remoteDataSource;

  HistoryRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<List<HistoryEntryEntity>> getHistory() {
    try {
      return remoteDataSource.getHistory();
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<void> addHistoryEntry(ComicEntity comic) async {
    try {
      await remoteDataSource.addHistoryEntry(comic);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<void> deleteHistoryEntry(String id) async {
    try {
      await remoteDataSource.deleteHistoryEntry(id);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<void> clearAllHistory() async {
    try {
      await remoteDataSource.clearAllHistory();
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }
}
