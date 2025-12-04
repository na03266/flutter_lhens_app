import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lhens_app/gen/assets.gen.dart';
import 'package:lhens_app/user/view/login_screen.dart'; // 경로 맞게 조정

class SplashScreen extends StatefulWidget {
  static String get routeName => 'splash';

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // 3초 딜레이 후 로그인 화면으로 이동
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return; // 위젯이 이미 dispose 된 경우 방지
      context.goNamed(LoginScreen.routeName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
          onTap:(){
            context.goNamed(LoginScreen.routeName);
          },
        child: SizedBox.expand(
          child: Image.asset(Assets.images.splashV2.path, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
