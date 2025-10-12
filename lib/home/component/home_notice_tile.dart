import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';

class NoticeTile extends StatelessWidget {
  final String title;
  final String date;
  final bool isNew;
  final VoidCallback? onTap;

  const NoticeTile({
    super.key,
    required this.title,
    required this.date,
    this.isNew = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 8.w),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.borderStrong)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // NEW
            if (isNew)
              Text(
                "NEW",
                style: AppTextStyles.pb16.copyWith(color: AppColors.primary),
              ),
            if (isNew) SizedBox(width: 9.w),
            // 제목
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.pm16.copyWith(color: AppColors.text),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 10.w),
            // 날짜
            Text(
              date,
              style: AppTextStyles.pr16.copyWith(color: AppColors.textTer),
            ),
          ],
        ),
      ),
    );
  }
}
