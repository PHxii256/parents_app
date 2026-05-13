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

  Future<void> connect({required int tripId}) async {
    if (!ApiConfig.useRealApi) return;
    if (_socket != null && _connectedTripId == tripId) return;

    await disconnect();
    final tokens = await _jwtStorage.load();
    final token = tokens?.accessToken;
    if (token == null || token.isEmpty) return;

    final wsUri = _buildTripWsUri(tripId: tripId, token: token);
    try {
      _socket = await WebSocket.connect(wsUri.toString());
      _connectedTripId = tripId;
      _socketSubscription = _socket!.listen(
        _onRawMessage,
        onError: (_) => _onSocketEnded(),
        onDone: _onSocketEnded,
        cancelOnError: true,
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[TripSocket] connect failed for trip=$tripId: $e');
      }
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
  }

  Future<void> dispose() async {
    await disconnect();
    await _eventsController.close();
  }

  void _onRawMessage(dynamic raw) {
    try {
      final decoded = jsonDecode(raw.toString());
      if (decoded is! Map) return;
      final map = <String, dynamic>{};
      decoded.forEach((k, v) => map[k.toString()] = v);
      final event = TripSocketEvent.fromJson(map);
      if (event != null) {
        _eventsController.add(event);
      }
    } catch (_) {}
  }

  void _onSocketEnded() {
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
