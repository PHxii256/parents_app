import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parent_app/features/notifications/cubit/notifications_state.dart';
import 'package:parent_app/features/notifications/data/models/notification_history_item.dart';
import 'package:parent_app/features/notifications/data/repositories/notifications_repository.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationsRepository _repository;
  StreamSubscription<NotificationHistoryItem>? _incomingSubscription;
  bool _isInitialized = false;
  bool _isInitializing = false;

  NotificationsCubit({required NotificationsRepository repository})
    : _repository = repository,
      super(NotificationsState.initial());

  Future<void> init() async {
    if (_isInitialized || _isInitializing) return;
    _isInitializing = true;
    try {
      final history = await _repository.loadHistory();
      emit(state.copyWith(loading: false, history: history, unreadCount: 0, clearError: true));

      await _repository.initializeMessaging();

      _incomingSubscription = _repository.incomingMessages.listen((incoming) {
        final updated = [incoming, ...state.history];
        emit(
          state.copyWith(history: updated, unreadCount: state.unreadCount + 1, clearError: true),
        );
      });
      _isInitialized = true;
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    } finally {
      _isInitializing = false;
    }
  }

  Future<void> clearHistory() async {
    await _repository.clearHistory();
    emit(state.copyWith(history: [], unreadCount: 0));
  }

  void markAllAsRead() {
    if (state.unreadCount == 0) return;
    emit(state.copyWith(unreadCount: 0));
  }

  @override
  Future<void> close() async {
    await _incomingSubscription?.cancel();
    await _repository.dispose();
    return super.close();
  }
}
