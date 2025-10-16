import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:lhens_app/common/components/label_value_line.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';

class EduEventListItem extends StatelessWidget {
  final String typeName; // 유형명
  final String title;
  final String targetDept; // 수신부서
  final String periodText; // 기간
  final VoidCallback? onTap;

  const EduEventListItem({
    super.key,
    required this.typeName,
    required this.title,
    required this.targetDept,
    required this.periodText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.borderStrong)),
        ),
        padding: EdgeInsets.only(top: 4.h, bottom: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 유형명
            Text(
              typeName,
              style: AppTextStyles.pb13.copyWith(color: AppColors.secAccent),
            ),
            SizedBox(height: 6.h),

            // 제목
            Text(
              title,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.pm16.copyWith(
                color: AppColors.text,
                height: 1.35,
                letterSpacing: -0.40,
              ),
            ),
            SizedBox(height: 8.h),

            // 수신부서 / 기간
            LabelValueLine.single(
              label1: '수신부서',
              value1: targetDept,
              labelWidth: 52,
              gapBetween: 8,
              labelStyle: AppTextStyles.pb14.copyWith(color: AppColors.textTer),
              valueStyle: AppTextStyles.pr14.copyWith(color: AppColors.textTer),
            ),
            SizedBox(height: 6.h),
            LabelValueLine.single(
              label1: '기간',
              value1: periodText,
              labelWidth: 52,
              gapBetween: 8,
              labelStyle: AppTextStyles.pb14.copyWith(color: AppColors.textTer),
              valueStyle: AppTextStyles.pr14.copyWith(color: AppColors.textTer),
            ),
          ],
        ),
      ),
    );
  }
}
