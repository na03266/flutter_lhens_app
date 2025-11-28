import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lhens_app/alarm/view/alarm_screen.dart';
import 'package:lhens_app/common/components/dialogs/confirm_dialog.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/drawer/component/drawer_body_section.dart';
import 'package:lhens_app/drawer/component/drawer_header_section.dart';

import '../../user/auth/provider/auth_provider.dart';
import '../../user/model/user_model.dart';
import '../../user/provider/user_me_provier.dart';

class CustomDrawer extends ConsumerWidget {
  final bool hasNewAlarm;

  const CustomDrawer({super.key, this.hasNewAlarm = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mb = ref.watch(userMeProvider);
    final state = mb is UserModel;
    return Drawer(
      backgroundColor: AppColors.white,
      shape: const ContinuousRectangleBorder(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DrawerHeaderSection(
            userName: state ? mb.mbName : '',
            dept: state ? mb.mbDepart : '',
            position: state ? mb.mb5 : '',
            empNo: state ? mb.mbId : '',
            joinDate: state ? mb.mb3 : '',
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
