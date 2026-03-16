import 'package:parent_app/features/notifications/data/models/notification_history_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationHistoryStore {
  static const String _historyKey = 'fcm_notification_history';
  static const int _maxEntries = 100;

  Future<List<NotificationHistoryItem>> readAll() async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = prefs.getStringList(_historyKey) ?? const [];
    final items = rawList.map(NotificationHistoryItem.decode).toList();
    items.sort((a, b) => b.receivedAt.compareTo(a.receivedAt));
    return items;
  }

  Future<void> append(NotificationHistoryItem item) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getStringList(_historyKey) ?? <String>[];
    current.insert(0, item.encode());
    if (current.length > _maxEntries) {
      current.removeRange(_maxEntries, current.length);
    }
    await prefs.setStringList(_historyKey, current);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }
}
