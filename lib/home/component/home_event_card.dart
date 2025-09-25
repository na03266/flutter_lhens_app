// home/component/home_event_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';

class HomeEventCard extends StatelessWidget {
  const HomeEventCard({
    super.key,
    required this.title,
    required this.periodText,
    required this.imagePath,
    this.onTap,
    this.width,
  });

  final String title;
  final String periodText;
  final String imagePath;
  final VoidCallback? onTap;

  /// 외부에서 카드 가로폭 지정 가능 (없으면 252.w)
  final double? width;

  @override
  Widget build(BuildContext context) {
    final cardW = width ?? 252.w;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: cardW,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: AspectRatio(
                aspectRatio: 3 / 2, // 3:2 비율
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover, // 비율 맞추고 잘라내기
                ),
              ),
            ),
            SizedBox(height: 16.h),

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
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '기간',
                    style: AppTextStyles.psb12.copyWith(
                      color: AppColors.textTer,
                    ),
                  ),
                  WidgetSpan(child: SizedBox(width: 4)),
                  TextSpan(
                    text: periodText,
                    style: AppTextStyles.pr12.copyWith(
                      color: AppColors.textTer,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
