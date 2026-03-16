import 'dart:async';

import 'package:parent_app/features/notifications/data/models/notification_history_item.dart';
import 'package:parent_app/features/notifications/data/services/fcm_service.dart';
import 'package:parent_app/features/notifications/data/services/notification_history_store.dart';

class NotificationsRepository {
  final NotificationHistoryStore _historyStore;
  final FcmService _fcmService;

  NotificationsRepository({NotificationHistoryStore? historyStore, FcmService? fcmService})
    : _historyStore = historyStore ?? NotificationHistoryStore(),
      _fcmService = fcmService ?? FcmService();

  Future<void> initializeMessaging() => _fcmService.initialize();

  Stream<NotificationHistoryItem> get incomingMessages => _fcmService.incomingMessages;

  Future<List<NotificationHistoryItem>> loadHistory() => _historyStore.readAll();

  Future<void> clearHistory() => _historyStore.clear();

  Future<void> dispose() => _fcmService.dispose();
}
