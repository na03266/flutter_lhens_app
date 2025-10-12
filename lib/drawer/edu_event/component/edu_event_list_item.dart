import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';
import 'package:lhens_app/gen/assets.gen.dart';

class EduEventListItem extends StatelessWidget {
  final String typeName; // '교육정보' | '행사정보'
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
          border: Border(
            bottom: BorderSide(color: AppColors.border),
          ),
        ),
        padding: EdgeInsets.only(top: 4.h, bottom: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상단 유형 라벨
            Row(
              children: [
                // 디자인 시안: 카테고리 단순 텍스트 라벨 (테두리 없음)
                Text(
                  typeName,
                  style: AppTextStyles.pm13.copyWith(color: AppColors.textSec),
                ),
                const Spacer(),
              ],
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

            // 수신부서
            _labelValue('수신부서', targetDept),
            SizedBox(height: 6.h),

            // 기간
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 52.w,
                  child: Text(
                    '기간',
                    style: AppTextStyles.pb14.copyWith(color: AppColors.textTer),
                  ),
                ),
                Expanded(
                  child: Text(
                    periodText,
                    style: AppTextStyles.pr14.copyWith(color: AppColors.textTer),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _labelValue(String label, String value) {
    return Row(
      children: [
        SizedBox(
          width: 52.w,
          child: Text(
            label,
            style: AppTextStyles.pb14.copyWith(color: AppColors.textTer),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.pr14.copyWith(color: AppColors.textTer),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
