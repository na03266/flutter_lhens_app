import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lhens_app/gen/assets.gen.dart';
import '../../common/theme/app_colors.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key, this.onTapMenu});

  final VoidCallback? onTapMenu;

  @override
  Size get preferredSize => Size.fromHeight(56.h);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.secondary,
          border: Border(
            bottom: BorderSide(color: AppColors.secondary, width: 0),
          ),
        ),
        child: SafeArea(
          child: Container(
            height: preferredSize.height,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                Assets.logos.logoSecondary.svg(height: 24.h),
                const Spacer(),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap:
                      onTapMenu ??
                      () => Scaffold.maybeOf(context)?.openEndDrawer(),
                  child: Padding(
                    padding: EdgeInsets.all(4.w),
                    child: Assets.icons.menu.svg(
                      width: 24.w,
                      height: 24.w,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
