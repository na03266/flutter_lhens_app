import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';

class NoticeTile extends StatelessWidget {
  final String title; // 공지 제목
  final String date; // 공지 날짜
  final bool isNew; // NEW 뱃지 표시 여부

  const NoticeTile({
    super.key,
    required this.title,
    required this.date,
    this.isNew = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 8.w),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.borderStrong)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // NEW 뱃지
          if (isNew)
            Text(
              "NEW",
              style: AppTextStyles.pb16.copyWith(color: AppColors.primary),
            ),
          if (isNew) SizedBox(width: 9.w),

          // 제목 (한 줄 제한)
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
    );
  }
}
