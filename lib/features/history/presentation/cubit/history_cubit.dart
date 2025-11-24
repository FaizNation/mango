import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mango/core/error/failure.dart';
import 'package:mango/core/usecase/usecase.dart';
import 'package:mango/features/history/domain/entities/history_entry_entity.dart';
import 'package:mango/features/history/domain/usecases/clear_all_history.dart';
import 'package:mango/features/history/domain/usecases/delete_history_entry.dart';
import 'package:mango/features/history/domain/usecases/get_history.dart';

part 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  final GetHistory _getHistory;
  final DeleteHistoryEntry _deleteHistoryEntry;
  final ClearAllHistory _clearAllHistory;
  StreamSubscription? _historySubscription;

  HistoryCubit({
    required GetHistory getHistory,
    required DeleteHistoryEntry deleteHistoryEntry,
    required ClearAllHistory clearAllHistory,
  })  : _getHistory = getHistory,
        _deleteHistoryEntry = deleteHistoryEntry,
        _clearAllHistory = clearAllHistory,
        super(const HistoryState()) {
    _monitorHistory();
  }

  void _monitorHistory() {
    emit(state.copyWith(status: HistoryStatus.loading));
    _historySubscription = _getHistory(NoParams()).listen((history) {
      emit(state.copyWith(
        status: HistoryStatus.success,
        history: history,
      ));
    }, onError: (error) {
      if (error is ServerFailure) {
        emit(state.copyWith(status: HistoryStatus.failure, errorMessage: error.message));
      } else {
        emit(state.copyWith(status: HistoryStatus.failure, errorMessage: 'An unknown error occurred'));
      }
    });
  }

  Future<void> deleteHistoryEntry(String id) async {
    try {
      await _deleteHistoryEntry(DeleteHistoryEntryParams(id: id));
    } on ServerFailure catch (e) {
      // The stream will eventually report the new state, but we can show an error
      // This is a good place for a transient error state, maybe with another stream in the cubit.
      // For now, we'll just let the stream update handle it. The cubit's main state
      // should reflect the source of truth (the stream).
      print('Failed to delete history entry: ${e.message}');
    }
  }

  Future<void> clearAllHistory() async {
    try {
      await _clearAllHistory(NoParams());
    } on ServerFailure catch (e) {
      print('Failed to clear history: ${e.message}');
    }
  }

  @override
  Future<void> close() {
    _historySubscription?.cancel();
    return super.close();
  }
}
