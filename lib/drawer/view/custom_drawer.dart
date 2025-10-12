import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lhens_app/alarm/view/alarm_screen.dart';
import 'package:lhens_app/drawer/component/drawer_header_section.dart';
import 'package:lhens_app/drawer/component/drawer_body_section.dart';
import '../../common/theme/app_colors.dart';

class CustomDrawer extends StatelessWidget {
  final bool hasNewAlarm;

  const CustomDrawer({
    super.key,
    this.hasNewAlarm = true,
  });

  @override
  Widget build(BuildContext context) {
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
            onTapBell: () {
              // 1) 드로어 닫기
              Navigator.of(context).maybePop();
              // 2) 알림 화면으로 이동
              Future.microtask(() => GoRouter.of(context).goNamed(AlarmScreen.routeName));
            },
          ),
          Expanded(
            child: DrawerBodySection(
              onLogout: () {
                // TODO: 로그아웃 처리
              },
            ),
          ),
        ],
      ),
    );
  }
}