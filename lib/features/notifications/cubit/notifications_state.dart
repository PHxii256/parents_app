import 'package:parent_app/features/notifications/data/models/notification_history_item.dart';

class NotificationsState {
  final bool loading;
  final List<NotificationHistoryItem> history;
  final int unreadCount;
  final String? error;

  const NotificationsState({
    required this.loading,
    required this.history,
    required this.unreadCount,
    required this.error,
  });

  factory NotificationsState.initial() {
    return const NotificationsState(loading: true, history: [], unreadCount: 0, error: null);
  }

  NotificationsState copyWith({
    bool? loading,
    List<NotificationHistoryItem>? history,
    int? unreadCount,
    String? error,
    bool clearError = false,
  }) {
    return NotificationsState(
      loading: loading ?? this.loading,
      history: history ?? this.history,
      unreadCount: unreadCount ?? this.unreadCount,
      error: clearError ? null : (error ?? this.error),
    );
  }
}
