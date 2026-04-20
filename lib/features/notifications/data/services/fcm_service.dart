import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:parent_app/features/notifications/data/models/notification_history_item.dart';
import 'package:parent_app/features/notifications/data/services/notification_history_store.dart';
import 'package:parent_app/firebase_options.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FcmService.storeRemoteMessage(message: message, source: 'background');
}

class FcmService {
  static const AndroidNotificationChannel _foregroundChannel = AndroidNotificationChannel(
    'fcm_foreground_channel',
    'Foreground Notifications',
    description: 'Displays push notifications while the app is open.',
    importance: Importance.high,
  );

  final NotificationHistoryStore _historyStore;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  final StreamController<NotificationHistoryItem> _incomingController =
      StreamController<NotificationHistoryItem>.broadcast();

  StreamSubscription<RemoteMessage>? _onMessageSubscription;
  StreamSubscription<RemoteMessage>? _onMessageOpenedSubscription;
  bool _localNotificationsReady = false;

  FcmService({NotificationHistoryStore? historyStore})
    : _historyStore = historyStore ?? NotificationHistoryStore();

  Stream<NotificationHistoryItem> get incomingMessages => _incomingController.stream;

  Future<String?> getCurrentToken() => FirebaseMessaging.instance.getToken();

  static Future<void> storeRemoteMessage({
    required RemoteMessage message,
    required String source,
  }) async {
    final historyStore = NotificationHistoryStore();
    final item = _mapRemoteMessage(message: message, source: source);
    await historyStore.append(item);
  }

  Future<void> initialize() async {
    if (!kIsWeb) {
      final settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        return;
      }
    }

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    await _initializeLocalNotifications();
    final token = await getCurrentToken();
    debugPrint('FCM token: $token');

    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      final item = _mapRemoteMessage(message: initialMessage, source: 'launch');
      await _historyStore.append(item);
      _incomingController.add(item);
    }

    _onMessageSubscription = FirebaseMessaging.onMessage.listen((message) async {
      final item = _mapRemoteMessage(message: message, source: 'foreground');
      await _historyStore.append(item);
      await _showForegroundNotification(message);
      _incomingController.add(item);
    });

    _onMessageOpenedSubscription = FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      final item = _mapRemoteMessage(message: message, source: 'opened_app');
      await _historyStore.append(item);
      _incomingController.add(item);
    });
  }

  Future<void> dispose() async {
    await _onMessageSubscription?.cancel();
    await _onMessageOpenedSubscription?.cancel();
    await _incomingController.close();
  }

  Future<void> _initializeLocalNotifications() async {
    if (_localNotificationsReady || kIsWeb) return;

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();

    const initSettings = InitializationSettings(android: androidSettings, iOS: iosSettings);
    await _localNotifications.initialize(initSettings);

    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_foregroundChannel);

    _localNotificationsReady = true;
  }

  Future<void> _showForegroundNotification(RemoteMessage message) async {
    if (kIsWeb || !_localNotificationsReady) return;

    final title =
        message.notification?.title ?? message.data['title']?.toString() ?? 'New notification';
    final body = message.notification?.body ?? message.data['body']?.toString() ?? '';

    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        _foregroundChannel.id,
        _foregroundChannel.name,
        channelDescription: _foregroundChannel.description,
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: const DarwinNotificationDetails(),
    );

    await _localNotifications.show(
      message.hashCode,
      title,
      body,
      details,
      payload: message.messageId,
    );
  }

  static NotificationHistoryItem _mapRemoteMessage({
    required RemoteMessage message,
    required String source,
  }) {
    final title = message.notification?.title ?? message.data['title'] ?? 'New notification';
    final body = message.notification?.body ?? message.data['body'] ?? '';

    return NotificationHistoryItem(
      id: message.messageId ?? '${DateTime.now().microsecondsSinceEpoch}',
      title: title.toString(),
      body: body.toString(),
      receivedAt: DateTime.now(),
      data: message.data.map((key, value) => MapEntry(key, value.toString())),
      source: source,
    );
  }
}
