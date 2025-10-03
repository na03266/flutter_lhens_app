import 'package:go_router/go_router.dart';
import 'package:lhens_app/drawer/complaint/view/complaint_detail_screen.dart';
import 'package:lhens_app/drawer/complaint/view/complaint_form_screen.dart';
import 'package:lhens_app/drawer/complaint/view/complaint_screen.dart';
import 'package:lhens_app/drawer/salary/view/salary_screen.dart';
import 'package:lhens_app/drawer/salary/view/salary_auth_screen.dart';
import 'package:lhens_app/manual/view/manual_screen.dart';
import 'package:lhens_app/risk/view/risk_form_screen.dart';
import 'package:lhens_app/risk/view/risk_detail_screen.dart';
import 'package:lhens_app/user/view/reset_password_screen.dart';
import 'package:lhens_app/user/view/user_picker_screen.dart';

import '../../alarm/view/alarm_screen.dart';
import '../../drawer/notice/view/notice_screen.dart';
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
            path: 'complaint',
            name: ComplaintScreen.routeName, // ex: 'complaint_list'
            pageBuilder: (context, state) =>
            const NoTransitionPage(child: ComplaintScreen()),
            routes: [
              GoRoute(
                path: 'form',
                name: ComplaintFormScreen.routeName, // ex: 'complaint_form'
                pageBuilder: (context, state) =>
                const NoTransitionPage(child: ComplaintFormScreen()),
              ),
              GoRoute(
                path: 'detail',
                name: ComplaintDetailScreen.routeName, // ex: 'complaint_detail'
                pageBuilder: (context, state) =>
                const NoTransitionPage(child: ComplaintDetailScreen()),
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
            pageBuilder: (_, __) =>
            const NoTransitionPage(child: MyPageScreen()),
            routes: [
              GoRoute(
                path: 'change-info',
                name: ChangeInfoScreen.routeName,
                pageBuilder: (_, __) =>
                const NoTransitionPage(child: ChangeInfoScreen()),
              ),
              GoRoute(
                path: 'my-risk',
                name: '내 위험신고 내역',
                pageBuilder: (_, __) => const NoTransitionPage(
                  child: RiskScreen(mineOnly: true, showFab: false),
                ),
                routes: [
                  GoRoute(
                    path: 'detail',
                    name: '내 위험신고 상세',
                    pageBuilder: (_, __) =>
                    const NoTransitionPage(child: RiskDetailScreen()),
                  ),
                  GoRoute(
                    path: 'form',
                    name: '내 위험신고 수정',
                    pageBuilder: (_, __) =>
                    const NoTransitionPage(child: RiskFormScreen()),
                  ),
                ],
              ),
              GoRoute(
                path: 'my-complaint',
                name: '내 민원제안 내역',
                pageBuilder: (_, __) => const NoTransitionPage(
                  child: ComplaintScreen(mineOnly: true, showFab: false),
                ),
                routes: [
                  GoRoute(
                    path: 'detail',
                    name: '내 민원제안 상세',
                    pageBuilder: (_, __) =>
                    const NoTransitionPage(child: ComplaintDetailScreen()),
                  ),
                  GoRoute(
                    path: 'form',
                    name: '내 민원제안 수정',
                    pageBuilder: (_, __) =>
                    const NoTransitionPage(child: ComplaintFormScreen()),
                  ),
                ],
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
        routes: [
          GoRoute(
            path: 'form',
            name: RiskFormScreen.routeName,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: RiskFormScreen()),
            routes: [
              GoRoute(
                path: 'user-picker',
                name: UserPickerScreen.routeName,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: UserPickerScreen()),
              ),
            ],
          ),
          GoRoute(
            path: 'detail',
            name: RiskDetailScreen.routeName,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: RiskDetailScreen()),
          ),
        ],
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
