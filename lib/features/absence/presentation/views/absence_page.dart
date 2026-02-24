import 'package:flutter/material.dart';

class AbsencePage extends StatelessWidget {
  const AbsencePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Absence", style: TextStyle(fontWeight: FontWeight.w500)),
      ),
    );
  }
}
