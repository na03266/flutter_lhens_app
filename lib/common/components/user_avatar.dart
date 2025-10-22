import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/gen/assets.gen.dart';

class UserAvatar extends StatelessWidget {
  final double size;
  final double iconSize;
  final Color? bg;

  const UserAvatar({
    super.key,
    this.size = 36,
    this.iconSize = 20,
    this.bg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.w,
      height: size.w,
      decoration: BoxDecoration(
        color: bg ?? AppColors.border,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Center(
        child: Assets.icons.user.svg(
          width: iconSize.w,
          height: iconSize.w,
        ),
      ),
    );
  }
}