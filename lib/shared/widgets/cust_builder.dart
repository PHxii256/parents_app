import 'package:flutter/material.dart';

class CustBuilder extends StatelessWidget {
  const CustBuilder({
    super.key,
    required bool loading,
    required String? error,
    required Widget success,
  }) : _loading = loading,
       _error = error,
       _success = success;

  final bool _loading;
  final String? _error;
  final Widget _success;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        if (_loading) return const Center(child: CircularProgressIndicator());
        if (_error != null) return Center(child: Text(_error, textAlign: TextAlign.center));
        return _success;
      },
    );
  }
}
