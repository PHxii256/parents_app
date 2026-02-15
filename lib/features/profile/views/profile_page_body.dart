import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          centerTitle: true,
          title: Text("Profile", style: TextStyle(fontWeight: FontWeight.w500)),
        ),
      ],
    );
  }
}
