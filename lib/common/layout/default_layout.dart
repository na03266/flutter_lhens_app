import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:lhens_app/common/components/app_bottom_nav.dart';
import 'package:lhens_app/common/components/custom_app_bar.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/home/component/home_app_bar.dart';

import '../../drawer/view/custom_drawer.dart';
import '../../home/view/home_screen.dart';
import '../../risk/view/risk_screen.dart';
import '../../chat/view/chat_screen.dart';
import '../../manual/view/manual_screen.dart';
import '../../home/my_page/view/my_page_screen.dart';

class DefaultLayout extends ConsumerWidget {
  final Color? backgroundColor;
  final Widget child;

  const DefaultLayout({super.key, required this.child, this.backgroundColor});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routeListenable = GoRouter.of(context).routerDelegate;

    return AnimatedBuilder(
      animation: routeListenable,
      builder: (context, _) {
        final state = GoRouterState.of(context);
        final path = state.uri.path;
        final isHome = path == '/home' || child is HomeScreen;

        final title = _resolveTitle(path);
        final rightType = _resolveRightType(path);
        final hideBottomBorder = _shouldHideAppBarBottom(path);

        return Scaffold(
          backgroundColor: backgroundColor ?? AppColors.white,
          appBar: isHome
              ? HomeAppBar()
              : CustomAppBar(
                  title: title,
                  rightType: rightType,
                  bottomBorder: hideBottomBorder
                      ? AppBarBottomBorder.none
                      : AppBarBottomBorder.thin,
                ),
          endDrawer: const CustomDrawer(),
          endDrawerEnableOpenDragGesture: false,
          body: child,
          bottomNavigationBar: AppBottomNav(
            onTapLeft1: () => _go(context, 0),
            onTapLeft2: () => _go(context, 1),
            onTapRight1: () => _go(context, 3),
            onTapRight2: () => _go(context, 4),
            onTapCenter: () => _goHome(context),
          ),
        );
      },
    );
  }

  // 타이틀
  String _resolveTitle(String path) {
    const map = {
      '/home/notice': '공지사항',
      '/home/salary': '급여명세서',
      '/home/complaint': '민원제안접수',
      '/home/my-page': '마이페이지',
      '/home/my-page/change-info': '정보변경',
      '/chat': '커뮤니케이션',
      '/risk': '위험신고',
      '/alarm': '알림',
      '/manual': '업무매뉴얼',
    };
    final hit = map[path];
    if (hit != null) return hit;
    for (final e in map.entries) {
      if (path.startsWith('${e.key}/')) return e.value;
    }
    return '';
  }

  // 오른쪽 아이콘 타입
  AppBarRightType _resolveRightType(String path) {
    if (path == '/home/my-page/change-info' ||
        path == '/home/salary/auth' ||
        path == '/risk/form') {
      return AppBarRightType.none;
    }
    return AppBarRightType.menu;
  }

  // 하단 보더
  bool _shouldHideAppBarBottom(String path) {
    // 목록 화면에서만 숨김 (정확히 일치)
    const exactHide = <String>{
      '/risk',
      '/alarm', // 알림도 목록만 숨기려면 유지, 아니면 지우세요
    };
    return exactHide.contains(path);
  }

  void _go(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.goNamed(RiskScreen.routeName);
        break;
      case 1:
        context.goNamed(ChatScreen.routeName);
        break;
      case 3:
        context.goNamed(ManualScreen.routeName);
        break;
      case 4:
        context.goNamed(MyPageScreen.routeName);
        break;
    }
  }

  void _goHome(BuildContext context) {
    context.goNamed(HomeScreen.routeName);
  }
}
