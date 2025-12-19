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
    this.iconSize = 60,
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
        alignment: Alignment.center, // 이 한 줄이 핵심
        color: bg ?? AppColors.border,
        child: icon != null
            ? icon!.image(
          fit: BoxFit.contain, // fitHeight 대신 contain 권장
          width: size.w * 0.9,
          height: size.w * 0.9,
        )
            : Assets.icons.user.svg(
          width: size.w * 0.7,
          height: size.w * 0.7,
        ),
      ),
    );
  }}
