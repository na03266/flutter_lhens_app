import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';

class AlarmListItem extends StatelessWidget {
  final String category;
  final String title;
  final String date;
  final bool read;
  final VoidCallback? onTap;

  const AlarmListItem({
    super.key,
    required this.category,
    required this.title,
    required this.date,
    required this.read,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final muted = read;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.border)),
        ),
        padding: EdgeInsets.only(top: 4.h, bottom: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 카테고리
            Text(
              category,
              style: AppTextStyles.pb14.copyWith(
                color: muted ? AppColors.placeholder : AppColors.secAccent,
              ),
            ),
            SizedBox(height: 8.h),
            // 제목
            Text(
              title,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.pm16.copyWith(
                color: muted ? AppColors.textTer : AppColors.text,
                height: 1.35,
                letterSpacing: -0.40,
              ),
            ),
            SizedBox(height: 8.h),
            // 날짜
            Text(
              date,
              style: AppTextStyles.pr14.copyWith(
                color: muted ? AppColors.placeholder : AppColors.textTer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
