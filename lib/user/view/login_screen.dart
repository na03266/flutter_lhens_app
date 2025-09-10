import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/compornts/button/CustomButton.dart';
import '../../common/compornts/input/CustomInput.dart';
import '../../common/provider/go_router.dart';
import '../../home/view/home_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static String get routeName => 'login';

  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _mbIdController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
  _mbIdController.dispose();
  _passwordController.dispose();
  super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 70),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'asset/image/common/logo.png',
                  width: 250, // 로고 크기 조정
                ),
                const SizedBox(height: 50), // 로고와 입력 폼 사이 간격
                CustomInput(
                  controller: _mbIdController,
                  label: '사번',
                ),
                const SizedBox(height: 10),
                CustomInput(
                  controller: _passwordController,
                  label: '비밀번호',
                  obscureText: true,
                ),
                const SizedBox(height: 15),
                CustomButton(
                  text: '로그인',
                  onPressed: () async {
                    _handleLogin(context, ref);
                  },
                ),
                const SizedBox(height: 23),
                CustomButton(
                  text: '비밀번호 찾기',
                  color: Colors.white,
                  onPressed: () {
                    // 비밀번호 찾기 누를시 관리 번호로 전화하도록 모달 표시
                  },
                ),
                // const ThemeModeSettingWidget(),
              ],
            ),
          ),
        ),
      // appBar: AppBar(title: const Text('Login')),
      // body: const Center(child: Text('로그인 화면')),
    );
  }



  Future<void> _handleLogin(BuildContext context, WidgetRef ref) async {

    final mbId = _mbIdController.text.trim();
    final mbPassword = _passwordController.text;

    // if (mbId.isEmpty || mbPassword.isEmpty) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('사번과 비밀번호를 모두 입력해주세요.')),
    //   );
    // }

    // setState(() => _isLoading = true);
    //
    // await ref.read(userMeProvider.notifier).login(
    //   mbId: mbId,
    //   mbPassword: mbPassword,
    // );
// ref.read(noticeProvider.notifier).fetchNoticeList();
    print('>> 로그인하기');

    // ref.read(routerProvider).go('/home');
    ref.read(routerProvider).goNamed(HomeScreen.routeName);
    // context.goNamed(HomeScreen.routeName);

    // final loginState = ref.read(authProvider);

    // print(loginState);
  }

  // 로그인 처리
  Future<void> _handleLogin2(mbId, mbPassword) async {

    final id = mbId.text.trim();
    final pw = mbPassword.text;

    try {
      // final user = await _authRepository.login(id, pw);
      // print('user: ${user}');
      setState(() => _isLoading = false);

      // 로그인 성공 처리: 예) 토큰 저장, 화면 전환
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }
}
