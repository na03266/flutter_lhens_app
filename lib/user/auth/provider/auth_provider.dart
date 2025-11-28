import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lhens_app/common/const/data.dart';
import 'package:lhens_app/common/secure_storage/secure_storage.dart';

import '../../model/user_model.dart';
import '../../provider/user_me_provier.dart';

final authTokenProvider = StateProvider<String?>((ref) => null);

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

  /// 임의 수정됨
  Future<String?> redirectLogic(
    BuildContext context,
    GoRouterState state,
  ) async {
    final user = ref.read(userMeProvider);
    final storage = ref.read(secureStorageProvider);
    final path = state.uri.path;

    final autologin = await storage.read(key: AUTO_LOGIN);

    // 루트는 홈으로
    if (path == '/') return '/home';

    // 스플래시는 통과점: 로그인 여부에 따라 바로 보냄
    if (path == '/login') {
      await Future.delayed(Duration(seconds: 3));
      if (user is UserModel) {
        return autologin != null ? '/home' : '/login';
      }

      if (user == null || user is UserModelError) return '/login';
      return null;
    }

    // 로그인 없이 접근 가능한 공개 경로
    const publicRoutes = {'/login', '/reset-password'};

    // 비로그인: 공개 경로만 허용, 아니면 로그인으로
    if (user == null || user is UserModelError) {
      return publicRoutes.contains(path) ? null : '/login';
    }

    // 로그인 상태: 로그인/재설정 페이지로 가면 홈으로 돌림
    if (user is UserModel && autologin != null) {
      if (path == '/login' || path == '/reset-password') return '/home';

      return null;
    }

    return null;
  }
}
