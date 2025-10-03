import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lhens_app/common/components/feedback/press_highlight.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';
import 'package:lhens_app/gen/assets.gen.dart';

class ReportDetailHeader extends StatelessWidget {
  final String typeName;
  final String title;
  final VoidCallback? onMoreTap;

  const ReportDetailHeader({
    super.key,
    required this.typeName,
    required this.title,
    this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16.w), // 오른쪽 여백 제거
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 왼쪽: 유형 + 제목
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  typeName,
                  style: AppTextStyles.pm14.copyWith(color: AppColors.textSec),
                ),
                SizedBox(height: 4.h),
                Text(
                  title,
                  softWrap: true,
                  style: AppTextStyles.psb18.copyWith(
                    color: AppColors.text,
                    height: 1.35,
                    letterSpacing: -0.45,
                  ),
                ),
              ],
            ),
          ),

          // 오른쪽: 더보기 버튼
          ConstrainedBox(
            constraints: BoxConstraints(minWidth: 40.w, minHeight: 40.w),
            child: PressHighlight(
              onTap: onMoreTap,
              child: Center(
                child: Assets.icons.more.svg(width: 24.w, height: 24.w),
              ),
            ),
          ),
        ],
      ),
    );
  }
}