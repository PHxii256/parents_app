import 'package:flutter/material.dart';

class ChangeRequestPage extends StatelessWidget {
  const ChangeRequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Request", style: TextStyle(fontWeight: FontWeight.w500)),
      ),
    );
  }
}
