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
import '../../menual/view/menual_screen.dart';
import '../../home/my_page/view/my_page_screen.dart';
import '../provider/app_bar_title_provider.dart';

class DefaultLayout extends ConsumerWidget {
  final Color? backgroundColor;
  final Widget child;

  const DefaultLayout({super.key, required this.child, this.backgroundColor});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = GoRouterState.of(context);
    final isHome = state.matchedLocation == '/home';
    final title = ref.watch(appBarTitleProvider);

    return Scaffold(
      backgroundColor: backgroundColor ?? AppColors.white,
      appBar: isHome ? HomeAppBar() : CustomAppBar(title: title),
      endDrawer: CustomDrawer(
        getTitle: (item) => ref.read(appBarTitleProvider.notifier).state = item,
      ),
      endDrawerEnableOpenDragGesture: false,
      body: child,
      bottomNavigationBar: AppBottomNav(
        onTapLeft1: () => _go(context, ref, 0),
        onTapLeft2: () => _go(context, ref, 1),
        onTapRight1: () => _go(context, ref, 3),
        onTapRight2: () => _go(context, ref, 4),
        onTapCenter: () => _goHome(context),
      ),
    );
  }

  void _go(BuildContext context, WidgetRef ref, int index) {
    switch (index) {
      case 0:
        context.goNamed(RiskScreen.routeName);
        ref.read(appBarTitleProvider.notifier).state = '위험신고';
        break;
      case 1:
        context.goNamed(ChatScreen.routeName);
        ref.read(appBarTitleProvider.notifier).state = '커뮤니케이션';
        break;
      case 3:
        context.goNamed(MenualScreen.routeName);
        ref.read(appBarTitleProvider.notifier).state = '업무매뉴얼';
        break;
      case 4:
        context.goNamed(MyPageScreen.routeName);
        ref.read(appBarTitleProvider.notifier).state = '마이페이지';
        break;
    }
  }

  void _goHome(BuildContext context) {
    context.goNamed(HomeScreen.routeName);
  }
}
