import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../common/const/appColorPicker.dart';
import '../../common/const/drawer_menus.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 헤더 영역
          Container(
            color: AppColors.primaryColor,
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 16.0,
            ),
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
                          fontSize: 22.0,
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
                const SizedBox(height: 8.0),
                const Text(
                  '[사업운영본부] 경인지사  |  차장',
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 4.0),
                const Text(
                  '사번 : 1001103   |   입사일 : 2018.01.15',
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 12.0),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primaryColor,
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white),
                        ),
                        onPressed: () {},
                        child: const Text('정보변경'),
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primaryColor,
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white),
                        ),
                        onPressed: () {},
                        child: const Text('마이페이지'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // 메뉴 리스트
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: drawerMenus.length,
              itemBuilder: (context, index) {
                final menu = drawerMenus[index];
                return Column(
                  children: [
                    ListTile(
                      title: Text(
                        menu.label,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        context.go(menu.route);
                      },
                    ),
                    const Divider(height: 1, color: AppColors.menuBorderColor),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              height: 48.0,
              child: OutlinedButton.icon(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.menuBorderColor),
                  foregroundColor: Colors.black,
                ),
                icon: const Icon(Icons.logout),
                label: const Text('로그아웃'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
