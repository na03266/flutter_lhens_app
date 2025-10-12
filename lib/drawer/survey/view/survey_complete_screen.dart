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
          // Background image
          Image.asset(
            Assets.illustrations.bgComplete.path,
            fit: BoxFit.cover,
          ),

          // Foreground content
          SafeArea(
            child: Stack(
              children: [
                // Top app bar spacer (DefaultLayout app bar will render above; we keep content centered)
                // Center content
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Illustration
                        Image.asset(
                          Assets.illustrations.illustComplete.path,
                          width: 214.w,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(height: 24.h),
                        // Title
                        Text(
                          '설문조사 완료',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.jb26.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        // Subtitle
                        Text(
                          '설문에 참여해주셔서 감사합니다',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.jm18.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
