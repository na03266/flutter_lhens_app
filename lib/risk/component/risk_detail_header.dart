import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';
import 'package:lhens_app/gen/assets.gen.dart';

class RiskDetailHeader extends StatelessWidget {
  final String typeName;
  final String title;
  final VoidCallback? onMoreTap;

  const RiskDetailHeader({
    super.key,
    required this.typeName,
    required this.title,
    this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // <-- stretch 제거
        children: [
          // 왼쪽: 유형 + 제목(여러 줄 허용)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(typeName,
                    style: AppTextStyles.pm14.copyWith(color: AppColors.textSec)),
                SizedBox(height: 4.h),
                Text(
                  title,
                  softWrap: true, // 상세는 전체 노출
                  style: AppTextStyles.psb18.copyWith(
                    color: AppColors.text,
                    height: 1.35,
                    letterSpacing: -0.45,
                  ),
                ),
              ],
            ),
          ),
          // 오른쪽: 더보기(고정 터치 영역)
          ConstrainedBox(
            constraints: BoxConstraints(minWidth: 40.w, minHeight: 40.w),
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
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