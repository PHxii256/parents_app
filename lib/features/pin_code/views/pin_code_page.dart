import 'package:flutter/material.dart';

class PinCodePage extends StatelessWidget {
  const PinCodePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Pin Code", style: TextStyle(fontWeight: FontWeight.w500)),
      ),
    );
  }
}
