import 'package:flutter/material.dart';

class LocationsPage extends StatelessWidget {
  const LocationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          centerTitle: true,
          title: Text("Locations", style: TextStyle(fontWeight: FontWeight.w500)),
        ),
      ],
    );
  }
}
