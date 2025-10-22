import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lhens_app/common/const/drawer_menus.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';
import 'package:lhens_app/common/components/exit_action_button.dart';

class DrawerBodySection extends StatelessWidget {
  final VoidCallback onLogout;

  const DrawerBodySection({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return ListView.builder(
      padding: EdgeInsets.fromLTRB(24, 0, 24, bottomInset),
      physics: const ClampingScrollPhysics(),
      itemCount: drawerMenuGroups.length + 1,
      itemBuilder: (context, i) {
        if (i < drawerMenuGroups.length) {
          final group = drawerMenuGroups[i];
          return _MenuGroupWidget(group: group, isFirst: i == 0);
        } else {
          return Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: ExitActionButton(
              label: '로그아웃',
              icon: const Icon(Icons.logout, size: 20, color: AppColors.text),
              onTap: onLogout,
            ),
          );
        }
      },
    );
  }
}

class _MenuGroupWidget extends StatelessWidget {
  final DrawerMenuGroup group;
  final bool isFirst;

  const _MenuGroupWidget({required this.group, required this.isFirst});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          top: isFirst
              ? const BorderSide(color: AppColors.border)
              : BorderSide.none,
          bottom: const BorderSide(color: AppColors.border),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Text(
            group.title,
            style: AppTextStyles.pb13.copyWith(color: AppColors.secondary),
          ),
          const SizedBox(height: 12),
          ...group.items.map(
                (it) => GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                final router = GoRouter.of(context);
                final messenger = ScaffoldMessenger.of(context);

                Navigator.of(context).maybePop();

                Future.microtask(() {
                  try {
                    router.goNamed(it.routeName);
                  } catch (_) {
                    messenger.showSnackBar(
                      const SnackBar(
                        content: Text('해당 화면은 준비중입니다.'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  }
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  it.label,
                  style: AppTextStyles.pm15.copyWith(color: AppColors.text),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
