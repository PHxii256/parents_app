import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          centerTitle: true,
          title: Text("Notifications", style: TextStyle(fontWeight: FontWeight.w500)),
        ),
      ],
    );
  }
}
