import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lhens_app/common/theme/app_colors.dart';

class AttachSurface extends StatelessWidget {
  final Widget child;
  final double minHeight;
  final EdgeInsets padding;

  const AttachSurface({
    super.key,
    required this.child,
    this.minHeight = 40,
    this.padding = const EdgeInsets.only(left: 8, right: 16, top: 6, bottom: 6),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: minHeight.h),
      padding: EdgeInsets.only(
        left: padding.left.w,
        right: padding.right.w,
        top: padding.top.h,
        bottom: padding.bottom.h,
      ),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: AppColors.border),
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
      child: child,
    );
  }
}
