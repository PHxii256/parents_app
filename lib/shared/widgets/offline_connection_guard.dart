import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class OfflineConnectionGuard extends StatefulWidget {
  final Widget child;

  const OfflineConnectionGuard({super.key, required this.child});

  @override
  State<OfflineConnectionGuard> createState() => _OfflineConnectionGuardState();
}

class _OfflineConnectionGuardState extends State<OfflineConnectionGuard> {
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _isOffline = false;
  bool _isDialogVisible = false;

  @override
  void initState() {
    super.initState();
    _initConnectivityMonitor();
  }

  Future<void> _initConnectivityMonitor() async {
    final current = await Connectivity().checkConnectivity();
    _updateOfflineState(current);

    _connectivitySubscription = Connectivity().onConnectivityChanged.listen(_updateOfflineState);
  }

  void _updateOfflineState(List<ConnectivityResult> results) {
    final hasConnection = results.any((result) => result != ConnectivityResult.none);
    if (_isOffline == !hasConnection) return;

    _isOffline = !hasConnection;
    if (_isOffline) {
      _showOfflineModal();
      return;
    }
    _dismissOfflineModal();
  }

  Future<void> _showOfflineModal() async {
    if (!mounted || _isDialogVisible) return;
    _isDialogVisible = true;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('You are offline'),
          content: const Text(
            'You are offline, unable to load data, please connect to the internet.',
          ),
          actions: [
            TextButton(
              onPressed: _isOffline ? null : () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );

    _isDialogVisible = false;
  }

  void _dismissOfflineModal() {
    if (!mounted || !_isDialogVisible) return;
    final rootNavigator = Navigator.of(context, rootNavigator: true);
    if (rootNavigator.canPop()) {
      rootNavigator.pop();
    }
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
