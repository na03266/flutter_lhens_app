import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';
import 'package:lhens_app/gen/assets.gen.dart';

class HomeSectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const HomeSectionHeader({super.key, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 6.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              title,
              style: AppTextStyles.jb18.copyWith(color: AppColors.text),
            ),
            Padding(
              padding: EdgeInsets.all(1.w),
              child: Assets.icons.plus.svg(width: 24.w, height: 24.w),
            ),
          ],
        ),
      ),
    );
  }
}
