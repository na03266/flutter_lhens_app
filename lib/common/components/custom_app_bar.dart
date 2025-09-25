// common/components/app_bar/custom_app_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lhens_app/common/components/feedback/press_highlight.dart';
import 'package:lhens_app/common/provider/app_bar_title_provider.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';
import '../../../gen/assets.gen.dart';
import '../theme/app_colors.dart';

enum AppBarRightType { none, menu, settings }

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String? title;
  final AppBarRightType rightType;
  final VoidCallback? onBack;
  final VoidCallback? onRightTap;

  const CustomAppBar({
    super.key,
    this.title,
    this.rightType = AppBarRightType.menu,
    this.onBack,
    this.onRightTap,
  });

  @override
  Size get preferredSize => Size.fromHeight(56.h);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final injectedTitle = ref.watch(appBarTitleProvider);
    final titleText = title ?? injectedTitle;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Container(
        color: AppColors.white,
        child: SafeArea(
          child: Container(
            height: preferredSize.height,
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: Row(
              children: [
                _IconButton(
                  onTap:
                      onBack ??
                      () async {
                        final popped = await Navigator.of(context).maybePop();
                        if (!popped) context.go('/home');
                      },
                  child: Assets.icons.arrowLeft.svg(width: 24.w, height: 24.w),
                ),
                Expanded(
                  child: Text(
                    titleText,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.pm18.copyWith(color: AppColors.text),
                  ),
                ),
                _buildRight(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRight(BuildContext context) {
    switch (rightType) {
      case AppBarRightType.menu:
        return Builder(
          builder: (c) => _IconButton(
            onTap: onRightTap ?? () => Scaffold.of(c).openEndDrawer(),
            child: Assets.icons.menu.svg(width: 24.w, height: 24.w),
          ),
        );
      case AppBarRightType.settings:
        return _IconButton(
          onTap: onRightTap ?? () {},
          child: Assets.icons.settings.svg(width: 24.w, height: 24.w),
        );
      case AppBarRightType.none:
        return SizedBox(width: 32.w);
    }
  }
}

class _IconButton extends StatelessWidget {
  const _IconButton({required this.onTap, required this.child});

  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return PressHighlight(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: child,
      ),
    );
  }
}
