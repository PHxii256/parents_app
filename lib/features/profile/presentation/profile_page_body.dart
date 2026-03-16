import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});


  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          centerTitle: true,
          title: Text("Profile", style: TextStyle(fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }
}
