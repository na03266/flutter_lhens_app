import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.iconPath,
    required this.message,
    this.iconSize = 52,
    this.width,
  });

  final String iconPath;
  final String message;
  final double iconSize;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: (width ?? 196.w)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Opacity(
              opacity: 0.2,
              child: SvgPicture.asset(
                iconPath,
                width: iconSize.w,
                height: iconSize.w,
                colorFilter: const ColorFilter.mode(
                  AppColors.muted,
                  BlendMode.srcIn,
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.pm14.copyWith(color: AppColors.textSec),
            ),
          ],
        ),
      ),
    );
  }
}
