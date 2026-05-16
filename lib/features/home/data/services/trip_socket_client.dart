import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:parent_app/core/config/api_config.dart';
import 'package:parent_app/features/auth/data/services/jwt_storage.dart';
import 'package:parent_app/features/home/data/models/trip_socket_event.dart';

class TripSocketClient {
  final JwtStorage _jwtStorage;
  final StreamController<TripSocketEvent> _eventsController =
      StreamController<TripSocketEvent>.broadcast();

  WebSocket? _socket;
  StreamSubscription? _socketSubscription;
  int? _connectedTripId;

  TripSocketClient({JwtStorage? jwtStorage}) : _jwtStorage = jwtStorage ?? JwtStorage();

  Stream<TripSocketEvent> get events => _eventsController.stream;

  bool get isConnected => _socket != null;

  void _log(String message) {
    if (kDebugMode) {
      debugPrint('[TripSocket] $message');
    }
  }

  Future<void> connect({required int tripId}) async {
    if (!ApiConfig.useRealApi) {
      _log('connect skipped (useRealApi=false) trip=$tripId');
      return;
    }
    if (_socket != null && _connectedTripId == tripId) {
      _log('already connected trip=$tripId');
      return;
    }

    await disconnect();
    final tokens = await _jwtStorage.load();
    final token = tokens?.accessToken;
    if (token == null || token.isEmpty) {
      _log('connect aborted: no JWT access token trip=$tripId');
      return;
    }

    final wsUri = _buildTripWsUri(tripId: tripId, token: token);
    final safeForLog = wsUri.replace(queryParameters: {'token': '***'});
    _log('connecting $safeForLog');
    try {
      _socket = await WebSocket.connect(wsUri.toString());
      _connectedTripId = tripId;
      _log('socket open trip=$tripId');
      _socketSubscription = _socket!.listen(
        _onRawMessage,
        onError: (Object e, _) {
          _log('socket error trip=$tripId err=$e');
          _onSocketEnded();
        },
        onDone: _onSocketEnded,
        cancelOnError: true,
      );
    } catch (e) {
      _log('connect failed trip=$tripId: $e');
      await disconnect();
    }
  }

  Future<void> disconnect() async {
    await _socketSubscription?.cancel();
    _socketSubscription = null;
    try {
      await _socket?.close();
    } catch (_) {}
    _socket = null;
    _connectedTripId = null;
    _log('disconnected');
  }

  Future<void> dispose() async {
    await disconnect();
    await _eventsController.close();
  }

  void _onRawMessage(dynamic raw) {
    final text = raw.toString();
    try {
      final decoded = jsonDecode(text);
      if (decoded is! Map) {
        _log('ignored non-object frame len=${text.length}');
        return;
      }
      final map = <String, dynamic>{};
      decoded.forEach((k, v) => map[k.toString()] = v);
      final preview = text.length > 200 ? '${text.substring(0, 200)}…' : text;
      _log('frame in: $preview');
      final event = TripSocketEvent.fromJson(map);
      if (event != null) {
        _eventsController.add(event);
      } else {
        _log('unparsed event type=${map['type']}');
      }
    } catch (e) {
      _log('frame parse error: $e');
    }
  }

  void _onSocketEnded() {
    _log('socket closed');
    _socketSubscription = null;
    _socket = null;
    _connectedTripId = null;
  }

  Uri _buildTripWsUri({required int tripId, required String token}) {
    final base = Uri.parse(ApiConfig.baseUrl);
    final wsScheme = base.scheme == 'https' ? 'wss' : 'ws';
    return base.replace(
      scheme: wsScheme,
      path: '/ws/trip/$tripId/',
      queryParameters: {'token': token},
    );
  }
}
