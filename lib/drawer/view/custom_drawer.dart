import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lhens_app/alarm/view/alarm_screen.dart';
import 'package:lhens_app/common/components/dialogs/confirm_dialog.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/drawer/component/drawer_body_section.dart';
import 'package:lhens_app/drawer/component/drawer_header_section.dart';

import '../../user/auth/provider/auth_provider.dart';

class CustomDrawer extends ConsumerWidget {
  final bool hasNewAlarm;

  const CustomDrawer({super.key, this.hasNewAlarm = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      backgroundColor: AppColors.white,
      shape: const ContinuousRectangleBorder(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DrawerHeaderSection(
            userName: '홍길동',
            dept: '사업운영본부 경영기획팀',
            position: '차장',
            empNo: '1001103',
            joinDate: '2018.01.15',
            hasNewAlarm: hasNewAlarm,
            onTapClose: () => Navigator.of(context).maybePop(),
            onTapBell: () async {
              Navigator.of(context).maybePop();
              await Future.delayed(const Duration(milliseconds: 10));
              if (!context.mounted) return;
              GoRouter.of(context).goNamed(AlarmScreen.routeName);
            },
          ),
          Expanded(
            child: DrawerBodySection(
              onLogout: () async {
                final ok = await ConfirmDialog.show(
                  context,
                  title: '로그아웃',
                  message: '로그아웃 하시겠습니까?',
                  destructive: true,
                  confirmText: '로그아웃',
                );

                if (!context.mounted) return;

                if (ok == true) {
                  ref.read(authProvider.notifier).logout();
                  Navigator.of(context).maybePop();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
