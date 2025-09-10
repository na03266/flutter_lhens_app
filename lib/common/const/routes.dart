import 'package:go_router/go_router.dart';

import '../../alarm/view/alarm_screen.dart';
import '../../drawer/notice/view/board_screen.dart';
import '../../chat/view/chat_screen.dart';
import '../../menual/view/menual_screen.dart';
import '../../risk/view/risk_screen.dart';
import '../../user/view/login_screen.dart';
import '../layout/default_layout.dart';
import '../../home/view/home_screen.dart';
import '../view/splash_screen.dart';

List<RouteBase> get routes => [
  // 네비게이션 없는 화면
  GoRoute(
    path: '/splash',
    name: SplashScreen.routeName,
    builder: (context, state) => SplashScreen(),
  ),
  GoRoute(
    path: '/login',
    name: LoginScreen.routeName,
    builder: (context, state) => LoginScreen(),
  ),

  // 네비게이션 있는 화면
  ShellRoute(
    builder: (context, state, child) => DefaultLayout(child: child),
    routes: [
      GoRoute(
        path: '/home',
        name: HomeScreen.routeName,
        builder: (context, state) => HomeScreen(),
      ),
      GoRoute(
        path: '/chat',
        name: ChatScreen.routeName,
        builder: (context, state) => ChatScreen(),
      ),
      GoRoute(
        path: '/risk',
        name: RiskScreen.routeName,
        builder: (context, state) => RiskScreen(),
      ),
      GoRoute(
        path: '/alarm',
        name: AlarmScreen.routeName,
        builder: (context, state) => AlarmScreen(),
      ),
      GoRoute(
        path: '/menual',
        name: MenualScreen.routeName,
        builder: (context, state) => MenualScreen(),
      ),
      GoRoute(
        path: '/notice',
        name: BoardScreen.routeName,
        builder: (context, state) => BoardScreen(),
      ),
    ],
  ),
];
