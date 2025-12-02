import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lhens_app/common/components/status_chip.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';
import 'package:lhens_app/mock/survey/mock_survey_models.dart';

class SurveyDetailHeader extends StatelessWidget {
  final bool isProcessing;
  final bool participated;
  final String title;

  const SurveyDetailHeader({
    super.key,
    required this.isProcessing,
    required this.participated,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 상태칩
          Row(
            children: [
              StatusChip(
                type: isProcessing ? StatusChipType.processing : StatusChipType.done,
                text: isProcessing ? '진행중' : '마감',
              ),
              SizedBox(width: 8.w),
              StatusChip(
                type: participated
                    ? StatusChipType.participate
                    : StatusChipType.notParticipate,
              ),
            ],
          ),
          SizedBox(height: 8.h),

          // 제목
          Text(
            title,
            style: AppTextStyles.psb18.copyWith(
              height: 1.35,
              letterSpacing: -0.45,
            ),
          ),
        ],
      ),
    );
  }
}
