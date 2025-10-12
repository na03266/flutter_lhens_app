import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:lhens_app/common/components/feedback/press_highlight.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/gen/assets.gen.dart';

enum AppBarRightType { none, menu, settings }

enum AppBarBottomBorder { none, thin }

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final AppBarRightType rightType;
  final AppBarBottomBorder bottomBorder;
  final VoidCallback? onBack;
  final VoidCallback? onRightTap;

  const CustomAppBar({
    super.key,
    this.title,
    this.rightType = AppBarRightType.menu,
    this.bottomBorder = AppBarBottomBorder.thin,
    this.onBack,
    this.onRightTap,
  });

  @override
  Size get preferredSize => Size.fromHeight(56.h);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Container(
        color: AppColors.white,
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: SizedBox(
                  height: preferredSize.height,
                  child: Row(
                    children: [
                      // 왼쪽 버튼
                      _IconButton(
                        onTap:
                            onBack ??
                            () {
                              final r = GoRouter.of(context);
                              if (r.canPop()) {
                                r.pop();
                              } else {
                                r.go('/home');
                              }
                            },
                        child: Assets.icons.arrowLeft.svg(
                          width: 24.w,
                          height: 24.w,
                        ),
                      ),

                      // 가운데 타이틀
                      Expanded(
                        child: Text(
                          title ?? '',
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.pm18.copyWith(
                            color: AppColors.text,
                          ),
                        ),
                      ),

                      // 오른쪽 아이콘
                      _buildRight(context),
                    ],
                  ),
                ),
              ),

              if (bottomBorder == AppBarBottomBorder.thin)
                const Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: SizedBox(
                    height: 1,
                    child: ColoredBox(color: AppColors.border),
                  ),
                ),
            ],
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
        return Builder(
          builder: (c) => _IconButton(
            onTap: onRightTap ?? () => Scaffold.of(c).openEndDrawer(),
            child: Assets.icons.settings.svg(width: 24.w, height: 24.w),
          ),
        );
      case AppBarRightType.none:
        return SizedBox(width: 44.w);
    }
  }
}

class _IconButton extends StatelessWidget {
  const _IconButton({required this.onTap, required this.child});

  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    const double minTouchSize = 44;

    return PressHighlight(
      onTap: onTap,
      child: SizedBox(
        width: minTouchSize,
        height: minTouchSize,
        child: Center(child: child),
      ),
    );
  }
}
