import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lhens_app/gen/assets.gen.dart'; // 경로 맞게 조정

class SplashScreen extends StatelessWidget {
  static String get routeName => 'splash';

  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Image.asset(Assets.images.splash.path, fit: BoxFit.cover),
      ),
    );
  }
}
