import 'dart:async';

import 'package:parent_app/features/guardian/data/guardian_repository.dart';
import 'package:parent_app/features/notifications/data/models/notification_history_item.dart';
import 'package:parent_app/features/notifications/data/services/fcm_service.dart';
import 'package:parent_app/features/notifications/data/services/notification_history_store.dart';

class NotificationsRepository {
  final NotificationHistoryStore _historyStore;
  final FcmService _fcmService;
  final GuardianRepository _guardianRepository;

  NotificationsRepository({
    NotificationHistoryStore? historyStore,
    FcmService? fcmService,
    GuardianRepository? guardianRepository,
  })
    : _historyStore = historyStore ?? NotificationHistoryStore(),
      _fcmService = fcmService ?? FcmService(),
      _guardianRepository = guardianRepository ?? GuardianRepository();

  Future<void> initializeMessaging() async {
    await _fcmService.initialize();
    final token = await _fcmService.getCurrentToken();
    await _guardianRepository.registerFcmToken(token);
  }

  Stream<NotificationHistoryItem> get incomingMessages => _fcmService.incomingMessages;

  Future<List<NotificationHistoryItem>> loadHistory() => _historyStore.readAll();

  Future<void> clearHistory() => _historyStore.clear();

  Future<void> dispose() => _fcmService.dispose();
}
