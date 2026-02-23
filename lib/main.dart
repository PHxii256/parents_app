import 'package:flutter/material.dart';
import 'package:parent_app/features/home/presentation//views/home_page.dart';
import 'package:parent_app/features/login/presentation/views/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        fontFamily: 'Lexend',
      ),
      home: LoginView(),
    );
  }
}
