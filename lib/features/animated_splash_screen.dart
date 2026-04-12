import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:parent_app/features/auth/presentation/auth_gate.dart';

class AnimatedSplashScreen extends StatefulWidget {
  const AnimatedSplashScreen({super.key});

  @override
  State<AnimatedSplashScreen> createState() => _AnimatedSplashScreenState();
}

class _AnimatedSplashScreenState extends State<AnimatedSplashScreen> {
  @override
  void initState() {
    super.initState();
    // سينتظر ٤ ثواني ثم ينتقل إلى صفحة التأكد من تسجيل الدخول
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AuthGate()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Lottie.asset(
          'assets/bus_anim.json', // تأكد من اسم الملف هنا
          width: 300,
          height: 300,
        ),
      ),
    );
  }
}