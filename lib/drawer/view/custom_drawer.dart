// drawer/view/custom_drawer.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lhens_app/common/components/buttons/app_button.dart';
import 'package:lhens_app/common/components/label_value_line.dart';

import '../../common/const/appColorPicker.dart';
import '../../common/const/drawer_menus.dart';

class CustomDrawer extends StatelessWidget {
  final Function(String) getTitle;
  const CustomDrawer({super.key, required this.getTitle});

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;

    return Drawer(
      backgroundColor: Colors.white,
      shape: const ContinuousRectangleBorder(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light,
            child: Container(
              color: AppColors.primaryColor,
              padding: EdgeInsets.fromLTRB(20, topInset + 12, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          '홍길동',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.of(context).maybePop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const LabelValueLine.double(
                    label1: '소속',
                    value1: '사업운영본부 경영기획팀',
                    label2: '직급',
                    value2: '차장',
                    labelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
                    valueStyle: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  const LabelValueLine.double(
                    label1: '사번',
                    value1: '1001103',
                    label2: '입사일',
                    value2: '2018.01.15',
                    labelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
                    valueStyle: TextStyle(color: Colors.white, fontSize: 14),
                  ),

                  const SizedBox(height: 16),
                  AppButton(
                    text: '마이페이지',
                    type: AppButtonType.plain,
                    height: 48.h,
                    onTap: () {
                      // TODO: 마이페이지 라우팅 연결
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: drawerMenus.length,
              itemBuilder: (context, index) {
                final menu = drawerMenus[index];
                return Column(
                  children: [
                    ListTile(
                      title: Text(menu.label, style: const TextStyle(fontWeight: FontWeight.w500)),
                      onTap: () {
                        Navigator.of(context).pop();
                        context.goNamed(menu.route);
                        getTitle(menu.label);
                      },
                    ),
                    const Divider(height: 1, color: AppColors.menuBorderColor),
                  ],
                );
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(20),
            child: SizedBox(
              height: 48,
              child: _LogoutButton(),
            ),
          ),
        ],
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton();

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: AppColors.menuBorderColor),
        foregroundColor: Colors.black,
      ),
      icon: const Icon(Icons.logout),
      label: const Text('로그아웃'),
    );
  }
}