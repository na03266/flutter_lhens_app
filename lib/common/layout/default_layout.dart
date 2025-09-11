import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lhens_app/alarm/view/alarm_screen.dart';
import 'package:lhens_app/chat/view/chat_screen.dart';
import 'package:lhens_app/home/view/home_screen.dart';

import '../../drawer/view/drawer.dart';
import '../../gen/assets.gen.dart';
import '../../menual/view/menual_screen.dart';
import '../../risk/view/risk_screen.dart';
import '../provider/app_bar_title_provider.dart';

class DefaultLayout extends ConsumerWidget {
  final Color? backgroundColor;
  final Widget child;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;

  const DefaultLayout({
    super.key,
    required this.child,
    this.backgroundColor,
    this.bottomNavigationBar,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).uri.toString();
    final isHome = location.endsWith('/home');

    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor ?? Colors.white,
        appBar: isHome ? null : renderAppBar(context, ref),
        endDrawer: CustomDrawer(
          getTitle: (item) {
            ref.read(appBarTitleProvider.notifier).state = item;
          },
        ),
        body: child,
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedFontSize: 12.0,
          unselectedFontSize: 12.0,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          currentIndex: _getIndex(location),
          onTap: (index) {
            switch (index) {
              case 0:
                context.goNamed(RiskScreen.routeName);
                ref.read(appBarTitleProvider.notifier).state =
                    RiskScreen.routeName;
                break;
              case 1:
                context.goNamed(ChatScreen.routeName);
                ref.read(appBarTitleProvider.notifier).state =
                    ChatScreen.routeName;
                break;
              case 2:
                context.goNamed(HomeScreen.routeName);
                break;
              case 3:
                context.goNamed(AlarmScreen.routeName);
                ref.read(appBarTitleProvider.notifier).state =
                    AlarmScreen.routeName;
                break;
              case 4:
                context.goNamed(MenualScreen.routeName);
                ref.read(appBarTitleProvider.notifier).state =
                    MenualScreen.routeName;
                break;
            }
          },
          items: [
            BottomNavigationBarItem(
              icon: Image.asset(Assets.image.menu.risk.path),
              label: RiskScreen.routeName,
            ),
            BottomNavigationBarItem(
              icon: Image.asset(Assets.image.menu.chat.path),
              label: ChatScreen.routeName,
            ),
            BottomNavigationBarItem(icon: SizedBox.shrink(), label: ''),
            BottomNavigationBarItem(
              icon: Image.asset(Assets.image.menu.alarm.path),
              label: AlarmScreen.routeName,
            ),
            BottomNavigationBarItem(
              icon: Image.asset(Assets.image.menu.manual.path),
              label: MenualScreen.routeName,
            ),
          ],
        ),
        floatingActionButton: Align(
          alignment: Alignment.bottomCenter,
          child: IconButton(
            onPressed: () => context.goNamed(HomeScreen.routeName),
            padding: EdgeInsets.zero,
            icon: Image.asset(Assets.image.menu.home.path),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  AppBar renderAppBar(BuildContext context, WidgetRef ref) {
    final title = ref.watch(appBarTitleProvider);

    // 타이틀이 빈 문자열이면 아예 텍스트 위젯도 안 넣기
    return AppBar(
      backgroundColor: Colors.white,
      // 홈일 때 색상 변경
      foregroundColor: Colors.black,
      // 글자색도 홈일 때 변경 가능
      elevation: 0.5,
      // 왼쪽: 뒤로가기 버튼 (뒤로갈 수 있을 때만)
      leading: context.canPop()
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(context),
            )
          : null,

      title: Text(
        title,
        style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
      ),
      // 오른쪽: 햄버거 메뉴 버튼 → endDrawer 열기
      actions: [
        Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openEndDrawer(),
          ),
        ),
      ],
    );
  }

  int _getIndex(String location) {
    if (location.startsWith('/risk')) return 0;
    if (location.startsWith('/chat')) return 1;
    if (location.startsWith('/home')) return 2;
    if (location.startsWith('/alarm')) return 3;
    if (location.startsWith('/menual')) return 4;
    return 2;
  }
}
