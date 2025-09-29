import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lhens_app/common/components/label_value_line.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_shadows.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';
import 'package:lhens_app/drawer/salary/view/salary_screen.dart';
import 'package:lhens_app/gen/assets.gen.dart';
import 'home_nav_card.dart';

class GreetingSection extends StatelessWidget {
  const GreetingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const GreetingCard(),
        SizedBox(height: 20.h),
        Row(
          children: [
            Expanded(
              child: HomeNavCard(
                title: '급여명세서',
                imagePath: Assets.illustrations.salary.path,
                onTap: () {
                  context.pushNamed(SalaryScreen.routeName);
                },
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: HomeNavCard(
                title: '민원제안접수',
                imagePath: Assets.illustrations.complaint.path,
                onTap: () {},
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: HomeNavCard(
                title: '설문조사',
                imagePath: Assets.illustrations.survey.path,
                onTap: () {},
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class GreetingCard extends StatelessWidget {
  const GreetingCard({super.key});

  @override
  Widget build(BuildContext context) {
    final imgSize = 104.w;
    final gap = 12.h;
    final reservedRight = imgSize * .6 + 12.w;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: AppShadows.card,
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(18.w, 24.h, reservedRight, 18.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '홍길동님',
                  style: AppTextStyles.jm18.copyWith(color: AppColors.white),
                ),
                SizedBox(height: 6.h),
                Text(
                  '오늘도 화이팅하세요!',
                  style: AppTextStyles.jm16.copyWith(color: AppColors.white),
                ),
                SizedBox(height: gap),
                LabelValueLine.double(
                  label1: '소속',
                  value1: '사업운영본부 경영기획팀',
                  label2: '직급',
                  value2: '차장',
                ),
                SizedBox(height: 4.h),
                LabelValueLine.double(
                  label1: '사번',
                  value1: '100103',
                  label2: '입사일',
                  value2: '2018.01.15',
                ),
              ],
            ),
          ),
          Positioned(
            right: -16,
            bottom: 0,
            child: Image.asset(
              Assets.illustrations.mainGreeting.path,
              width: imgSize,
              height: imgSize,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
