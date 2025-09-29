import 'package:go_router/go_router.dart';
import 'package:lhens_app/drawer/salary/view/salary_screen.dart';
import 'package:lhens_app/drawer/salary/view/salary_auth_screen.dart';
import 'package:lhens_app/manual/view/manual_screen.dart';
import 'package:lhens_app/user/view/reset_password_screen.dart';

import '../../alarm/view/alarm_screen.dart';
import '../../drawer/notice/view/board_screen.dart';
import '../../chat/view/chat_screen.dart';
import '../../home/my_page/change_info/view/change_info_screen.dart';
import '../../home/my_page/view/my_page_screen.dart';
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
    builder: (context, state) => const SplashScreen(),
  ),
  GoRoute(
    path: '/login',
    name: LoginScreen.routeName,
    builder: (context, state) => const LoginScreen(),
  ),
  GoRoute(
    path: '/reset-password',
    name: ResetPasswordScreen.routeName,
    builder: (context, state) => const ResetPasswordScreen(),
  ),

  // 네비게이션 있는 화면
  ShellRoute(
    builder: (context, state, child) => DefaultLayout(child: child),
    routes: [
      GoRoute(
        path: '/home',
        name: HomeScreen.routeName,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: HomeScreen()),
        routes: [
          GoRoute(
            path: 'salary',
            name: SalaryScreen.routeName,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: SalaryScreen()),
            routes: [
              GoRoute(
                path: 'auth',
                name: SalaryAuthScreen.routeName,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: SalaryAuthScreen()),
              ),
            ],
          ),
          GoRoute(
            path: 'notice',
            name: NoticeScreen.routeName,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: NoticeScreen()),
          ),
          GoRoute(
            path: 'my-page',
            name: MyPageScreen.routeName,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: MyPageScreen()),
            routes: [
              GoRoute(
                path: 'change-info',
                name: ChangeInfoScreen.routeName,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: ChangeInfoScreen()),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/chat',
        name: ChatScreen.routeName,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: ChatScreen()),
      ),
      GoRoute(
        path: '/risk',
        name: RiskScreen.routeName,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: RiskScreen()),
      ),
      GoRoute(
        path: '/alarm',
        name: AlarmScreen.routeName,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: AlarmScreen()),
      ),
      GoRoute(
        path: '/manual',
        name: ManualScreen.routeName,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: ManualScreen()),
      ),
    ],
  ),
];
