import 'package:flutter/material.dart';
import 'package:parent_app/features/login/presentation/login_page.dart';

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
        radioTheme: RadioThemeData(fillColor: WidgetStateProperty.all(Colors.black87)),
        fontFamily: 'Lexend',
      ),
      home: LoginPage(),
    );
  }
}
