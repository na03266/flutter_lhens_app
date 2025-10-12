import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';

class HomeEventCard extends StatelessWidget {
  final String title;
  final String periodText;
  final String imagePath;
  final VoidCallback? onTap;

  const HomeEventCard({
    super.key,
    required this.title,
    required this.periodText,
    required this.imagePath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 비율 3:2
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: AspectRatio(
              aspectRatio: 3 / 2,
              child: Image.asset(imagePath, fit: BoxFit.cover),
            ),
          ),
          SizedBox(height: 16.h),

          // 제목
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.psb18.copyWith(
              fontSize: 16.sp,
              color: AppColors.text,
            ),
          ),
          SizedBox(height: 6.h),

          // 기간
          Row(
            children: [
              Text(
                '기간',
                style: AppTextStyles.psb12.copyWith(color: AppColors.textTer),
              ),
              SizedBox(width: 4.w),
              Text(
                periodText,
                style: AppTextStyles.pr12.copyWith(color: AppColors.textTer),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
