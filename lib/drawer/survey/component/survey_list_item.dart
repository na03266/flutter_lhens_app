import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lhens_app/common/components/status_chip.dart';
import 'package:lhens_app/common/components/label_value_line.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';
import 'package:lhens_app/gen/assets.gen.dart';
import 'package:lhens_app/mock/survey/mock_survey_models.dart';

class SurveyListItem extends StatelessWidget {
  final SurveyStatus status;
  final String title;
  final String dateRangeText;
  final String author;
  final bool participated;
  final VoidCallback? onTap;

  const SurveyListItem({
    super.key,
    required this.status,
    required this.title,
    required this.dateRangeText,
    required this.author,
    required this.participated,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // 진행 상태 칩 타입 및 라벨 설정
    final statusType = status == SurveyStatus.ongoing
        ? StatusChipType.processing
        : StatusChipType.done;
    final statusLabel = status == SurveyStatus.ongoing ? '진행중' : '마감';

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
            // 상단 칩 영역
            Row(
              children: [
                StatusChip(type: statusType, text: statusLabel),
                SizedBox(width: 8.w),
                const Spacer(),
              ],
            ),
            SizedBox(height: 8.h),

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

            // 기간
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Assets.icons.calendar.svg(width: 15.w, height: 15.w),
                SizedBox(width: 5.w),
                Text(
                  dateRangeText,
                  style: AppTextStyles.pr14.copyWith(
                    color: AppColors.textSec,
                    height: 1,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),

            // 대상 / 작성자 / 참여여부
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LabelValueLine.single(
                        label1: '참여자 수',
                        value1: author,
                        labelWidth: 62,
                        labelStyle: AppTextStyles.pb14.copyWith(
                          color: AppColors.textTer,
                        ),
                        valueStyle: AppTextStyles.pr14.copyWith(
                          color: AppColors.textTer,
                        ),
                        gapBetween: 8,
                      ),
                    ],
                  ),
                ),
                StatusChip(
                  type: participated
                      ? StatusChipType.participate
                      : StatusChipType.notParticipate,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
