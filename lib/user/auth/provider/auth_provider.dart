import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../model/user_model.dart';
import '../../provider/user_me_provier.dart';

final authProvider = ChangeNotifierProvider<AuthProvider>((ref) {
  return AuthProvider(ref: ref);
});

class AuthProvider extends ChangeNotifier {
  final Ref ref;

  AuthProvider({required this.ref}) {
    ref.listen<UserModelBase?>(userMeProvider, (previous, next) {
      if (previous != next) {
        notifyListeners();
      }
    });
  }

  void logout() {
    ref.read(userMeProvider.notifier).logout();
  }

  // SplashScreen
  // 앱을 처음 시작 했을때,
  // 토큰이 존재하는지 확인하고
  // 로그인 스크린으로 보내줄지
  // 홈 스크린으로 보내줄지 확인하는 과정이 필요하다.

  FutureOr<String?> redirectLogic(BuildContext context, GoRouterState state) {
    final UserModelBase? user = ref.read(userMeProvider);
    final loggingIn = state.uri.path == '/login';
    final redirectToHome = state.uri.path == '/';

    if (redirectToHome) {
      return '/home';
    }

    // 유저 정보가 없는데
    // 로그인 중이면 그대로 로그인 페이지에 두고
    // 만약에 로그인 중이 아니라면 로그인 페이지로 이동.
    if (user == null) {
      return loggingIn ? null : '/login';
    }

    // user 가 null이 아님

    // UserModel
    // 사용자 정보가 있는 상태면
    // 로그인 중이거나 현재위치가 SplashScreen이면
    // 홈으로 이동
    if (user is UserModel) {
      return loggingIn || state.uri.path == '/splash' ? '/home' : null;
    }

    if (user is UserModelError) {
      return !loggingIn ? '/login' : null;
    }
    return null;
  }
}
