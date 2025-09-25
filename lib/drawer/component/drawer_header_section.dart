import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lhens_app/common/components/buttons/app_button.dart';
import 'package:lhens_app/common/components/label_value_line.dart';
import 'package:lhens_app/common/components/icon_with_dot.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';
import 'package:lhens_app/gen/assets.gen.dart';
import 'package:lhens_app/home/my_page/change_info/view/change_info_screen.dart';

class DrawerHeaderSection extends StatelessWidget {
  final String userName;
  final String dept;
  final String position;
  final String empNo;
  final String joinDate;
  final bool hasNewAlarm;
  final VoidCallback onTapClose;
  final VoidCallback onTapBell;

  const DrawerHeaderSection({
    super.key,
    required this.userName,
    required this.dept,
    required this.position,
    required this.empNo,
    required this.joinDate,
    required this.hasNewAlarm,
    required this.onTapClose,
    required this.onTapBell,
  });

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;
    const hit = 44.0;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Container(
        color: AppColors.primary,
        padding: EdgeInsets.fromLTRB(20, topInset + 12, 20, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상단 유저명 + 알림 + 닫기 버튼
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        '$userName님',
                        style: AppTextStyles.pb18.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: onTapBell,
                        child: SizedBox(
                          width: hit,
                          height: hit,
                          child: Center(
                            child: IconWithDot(
                              icon: Assets.icons.bell.svg(
                                width: 20,
                                height: 20,
                                colorFilter: const ColorFilter.mode(
                                  AppColors.white,
                                  BlendMode.srcIn,
                                ),
                              ),
                              showDot: hasNewAlarm,
                              dotType: DotType.yellow,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onTapClose,
                  child: SizedBox(
                    width: hit,
                    height: hit,
                    child: Center(
                      child: Assets.icons.close.svg(
                        width: 24,
                        height: 24,
                        colorFilter: const ColorFilter.mode(
                          AppColors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.h),

            // 소속 / 직급
            LabelValueLine.double(
              label1: '소속',
              value1: dept,
              label2: '직급',
              value2: position,
            ),
            SizedBox(height: 4.h),

            // 사번 / 입사일
            LabelValueLine.double(
              label1: '사번',
              value1: empNo,
              label2: '입사일',
              value2: joinDate,
            ),

            SizedBox(height: 16.h),

            // 마이페이지 버튼
            AppButton(
              text: '마이페이지',
              type: AppButtonType.plain,
              height: 48.h,
              onTap: () => context.goNamed(ChangeInfoScreen.routeName),
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }
}
