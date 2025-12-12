import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/gen/assets.gen.dart';

class UserAvatar extends StatelessWidget {
  final double size;
  final double iconSize;
  final Color? bg;
  final AssetGenImage? icon;

  const UserAvatar({
    super.key,
    this.size = 36,
    this.iconSize = 70,
    this.bg,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        width: size.w,
        height: size.w,
        color: bg ?? AppColors.border,
        child: icon != null
            ? icon!.image(
          fit: BoxFit.fitHeight,          // 가득 채우기
          width: double.infinity,
          height: double.infinity,
        )
            : Assets.icons.user.svg(
          width: size.w * 0.7,
          height: size.w * 0.7,
        ),
      ),
    );
  }}
