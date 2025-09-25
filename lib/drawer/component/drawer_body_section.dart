import 'package:flutter/material.dart';
import 'package:lhens_app/common/const/drawer_menus.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';
import 'package:lhens_app/common/components/exit_action_button.dart';

class DrawerBodySection extends StatelessWidget {
  final void Function(String label) onPicked;
  final VoidCallback onLogout;

  const DrawerBodySection({
    super.key,
    required this.onPicked,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return ListView.builder(
      padding: EdgeInsets.only(bottom: bottomInset),
      physics: const ClampingScrollPhysics(),
      itemCount: drawerMenuGroups.length + 1,
      itemBuilder: (context, i) {
        if (i < drawerMenuGroups.length) {
          final group = drawerMenuGroups[i];
          return _MenuGroupWidget(
            group: group,
            isFirst: i == 0,
            onPicked: onPicked,
          );
        }else {
          return Padding(
            padding: const EdgeInsets.only(right: 12, bottom: 16),
            child: ExitActionButton(
              label: '로그아웃',
              icon: const Icon(
                Icons.logout,
                size: 20,
                color: AppColors.text,
              ),
              onTap: onLogout,
            ),
          );
        }
      },
    );
  }
}

class _MenuGroupWidget extends StatelessWidget {
  const _MenuGroupWidget({
    required this.group,
    required this.isFirst,
    required this.onPicked,
  });

  final DrawerMenuGroup group;
  final bool isFirst;
  final void Function(String label) onPicked;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          top: isFirst
              ? const BorderSide(color: AppColors.border)
              : BorderSide.none,
          left: const BorderSide(color: AppColors.border),
          right: const BorderSide(color: AppColors.border),
          bottom: const BorderSide(color: AppColors.border),
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 그룹 타이틀
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              group.title,
              style: AppTextStyles.psb13.copyWith(color: AppColors.secondary),
            ),
          ),
          const SizedBox(height: 12),
          // 메뉴 아이템들
          ...group.items.map(
            (it) => InkWell(
              onTap: () => onPicked(it.label),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
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
