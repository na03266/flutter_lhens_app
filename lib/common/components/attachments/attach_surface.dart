import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lhens_app/common/theme/app_colors.dart';

class AttachSurface extends StatelessWidget {
  final Widget child;
  final double height;
  final EdgeInsets padding;

  const AttachSurface({
    super.key,
    required this.child,
    this.height = 40,
    this.padding = const EdgeInsets.only(left: 8, right: 16),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height.h,
      padding: EdgeInsets.only(left: padding.left.w, right: padding.right.w),
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
