import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';
import 'package:lhens_app/gen/assets.gen.dart';
import 'package:lhens_app/common/components/feedback/press_scale.dart';

class AttachButton extends StatelessWidget {
  final VoidCallback onTap;
  final String label;

  const AttachButton({
    super.key,
    required this.onTap,
    this.label = '파일첨부',
  });

  @override
  Widget build(BuildContext context) {
    return PressScale(
      onTap: onTap,
      child: Container(
        height: 40.h,
        padding: EdgeInsets.only(left: 8.w, right: 16.w),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: AppColors.border),
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 24.w,
              height: 24.w,
              child: Assets.icons.clip.svg(width: 20.w, height: 20.w),
            ),
            SizedBox(width: 6.w),
            Text(
              label,
              style: AppTextStyles.pm14.copyWith(color: AppColors.text),
            ),
          ],
        ),
      ),
    );
  }
}