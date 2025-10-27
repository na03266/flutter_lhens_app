import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lhens_app/alarm/view/alarm_screen.dart';

import 'package:lhens_app/common/components/app_bottom_nav.dart';
import 'package:lhens_app/common/components/custom_app_bar.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/home/component/home_app_bar.dart';

import '../../drawer/view/custom_drawer.dart';
import '../../home/view/home_screen.dart';
import '../../risk/view/risk_screen.dart';
import '../../chat/view/chat_screen.dart';
import '../../manual/view/manual_screen.dart';
import '../../chat/component/chat_settings_drawer.dart';

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
          endDrawer: _isChatDetail(path)
              ? ChatSettingsDrawer(pageContext: context)
              : const CustomDrawer(),
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
    if (path.endsWith('/user-picker')) {
      path = path.substring(0, path.length - '/user-picker'.length);
    }

    const map = {
      '/home/notice': '공지사항',
      '/home/salary': '급여명세서',
      '/home/complaint': '민원제안접수',
      '/home/edu-event': '교육행사정보',
      '/home/my-page': '마이페이지',
      '/home/my-page/change-info': '정보변경',
      '/home/my-page/my-risk': '내 위험신고 내역',
      '/home/my-page/my-complaint': '내 민원제안 내역',
      '/home/my-page/my-survey': '내 설문조사 내역',
      '/chat': '커뮤니케이션',
      '/risk': '위험신고',
      '/survey': '설문조사',
      '/alarm': '알림',
      '/manual': '업무매뉴얼',
    };

    if (map.containsKey(path)) return map[path]!;

    final candidates = map.keys.where((k) => path.startsWith(k)).toList()
      ..sort((a, b) => b.length.compareTo(a.length));
    return candidates.isNotEmpty ? map[candidates.first]! : '';
  }

  // 오른쪽 아이콘 타입
  AppBarRightType _resolveRightType(String path) {
    if (path == '/home/my-page/change-info' ||
        path == '/home/salary/auth' ||
        path == '/risk/form' ||
        path == '/risk/edit' ||
        path.startsWith('/home/my-page/my-risk/form') ||
        path == '/home/complaint/form' ||
        path == '/home/complaint/edit' ||
        path.startsWith('/home/my-page/my-complaint/form') ||
        path == '/user-picker' ||
        path.endsWith('/user-picker')) {
      return AppBarRightType.none;
    }

    if (path == '/chat/detail') {
      return AppBarRightType.settings;
    }

    return AppBarRightType.menu;
  }

  bool _isChatDetail(String path) => path == '/chat/detail';

  // 하단 보더
  bool _shouldHideAppBarBottom(String path) {
    const exactHide = <String>{
      '/risk',
      '/survey',
      '/alarm',
      '/home/notice',
      '/home/edu-event',
      '/home/my-page/my-risk',
      '/home/complaint',
      '/home/my-page/my-complaint',
      '/home/my-page/my-survey',
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
        context.goNamed(AlarmScreen.routeName);
        break;
    }
  }

  void _goHome(BuildContext context) {
    context.goNamed(HomeScreen.routeName);
  }
}
