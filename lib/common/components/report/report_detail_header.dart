import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      padding: EdgeInsets.only(left: 16.w, right: 10.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 유형 + 제목
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
                    height: 1.35,
                    letterSpacing: -0.45,
                  ),
                ),
              ],
            ),
          ),

          // 더보기 or 여백
          if (onMoreTap != null)
            SizedBox(
              width: 30.w,
              height: 40.w,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onMoreTap,
                child: Padding(
                  padding: EdgeInsets.only(top: 0.h), // 추후 필요시 여백 추가
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Assets.icons.more.svg(width: 24.w, height: 24.w),
                  ),
                ),
              ),
            )
          else
            SizedBox(width: 16.w),
        ],
      ),
    );
  }
}
