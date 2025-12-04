import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lhens_app/common/components/feedback/press_scale.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';

class MyNavCard extends StatelessWidget {
  const MyNavCard({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.width,
  });

  final Widget icon;
  final String title;
  final VoidCallback onTap;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final w = width ?? 96.w;

    return PressScale(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: w, minHeight: 44.h),
        child: SizedBox(
          width: w,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(width: 28.w, height: 28.w, child: icon),
              SizedBox(height: 6.h),
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppTextStyles.pm16.copyWith(color: AppColors.text),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
