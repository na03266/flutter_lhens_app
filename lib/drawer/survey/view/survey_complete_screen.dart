import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';
import 'package:lhens_app/gen/assets.gen.dart';

class SurveyCompleteScreen extends StatelessWidget {
  static String get routeName => '설문 완료';

  const SurveyCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 배경
          Image.asset(Assets.images.bgComplete4.path, fit: BoxFit.cover),
          SafeArea(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 일러스트
                    Image.asset(
                      Assets.illustrations.illustComplete.path,
                      width: 80.w,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: 24.h),

                    // 제목
                    Text(
                      '설문조사 완료',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.jb22.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                    SizedBox(height: 14.h),

                    // 안내 문구
                    Text(
                      '설문에 참여해주셔서 감사합니다',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.psb15.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                    SizedBox(height: 72.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
