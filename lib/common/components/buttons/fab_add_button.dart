import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lhens_app/common/components/feedback/press_scale.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_shadows.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';

class FabAddButton extends StatelessWidget {
  const FabAddButton({super.key, required this.onTap, this.label = '등록'});

  final VoidCallback onTap;
  final String label;

  @override
  Widget build(BuildContext context) {
    return PressScale(
      onTap: onTap,
      child: Container(
        height: 48.h,
        padding: EdgeInsets.only(
          top: 12.h,
          bottom: 12.h,
          left: 12.w,
          right: 18.w,
        ),
        decoration: ShapeDecoration(
          color: AppColors.secondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.r),
          ),
          shadows: AppShadows.homeButton,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add, size: 18.w, color: AppColors.white),
            SizedBox(width: 6.w),
            Text(
              label,
              style: AppTextStyles.pb16.copyWith(color: AppColors.white),
            ),
          ],
        ),
      ),
    );
  }
}
