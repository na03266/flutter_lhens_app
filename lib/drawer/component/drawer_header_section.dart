import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lhens_app/common/components/buttons/app_button.dart';
import 'package:lhens_app/common/components/icon_with_dot.dart';
import 'package:lhens_app/common/components/label_value_line.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';
import 'package:lhens_app/gen/assets.gen.dart';
import 'package:lhens_app/home/my_page/view/my_page_screen.dart';

class DrawerHeaderSection extends StatelessWidget {
  final String userName, dept, position, empNo, joinDate;
  final bool hasNewAlarm;
  final VoidCallback onTapClose, onTapBell;
  final ValueChanged<String> onPicked;

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
    required this.onPicked,
  });

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;
    final double hitSize = (44.w).clamp(44.0, double.infinity);
    final double padL = 20.w, padRForX = 8.w, padTop = 12.h, padBottom = 16.h;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Container(
        color: AppColors.primary,
        padding: EdgeInsets.fromLTRB(
          padL,
          topInset + padTop,
          padRForX,
          padBottom,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          '$userName님',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.pb18.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: onTapBell,
                        child: SizedBox(
                          width: hitSize,
                          height: hitSize,
                          child: Center(
                            child: IconWithDot(
                              icon: Assets.icons.bell.svg(
                                width: (20.w).clamp(18.0, 24.0),
                                height: (20.w).clamp(18.0, 24.0),
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
                    width: hitSize,
                    height: hitSize,
                    child: Center(
                      child: Assets.icons.close.svg(
                        width: (24.w).clamp(20.0, 28.0),
                        height: (24.w).clamp(20.0, 28.0),
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

            Padding(
              padding: EdgeInsets.only(right: (20.w - padRForX).clamp(0, 40.w)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 4.h),
                  LabelValueLine.double(
                    label1: '소속',
                    value1: dept,
                    label2: '직급',
                    value2: position,
                  ),
                  SizedBox(height: 4.h),
                  LabelValueLine.double(
                    label1: '사번',
                    value1: empNo,
                    label2: '입사일',
                    value2: joinDate,
                  ),
                  SizedBox(height: 16.h),
                  AppButton(
                    text: '마이페이지',
                    type: AppButtonType.plain,
                    height: 48.h,
                    onTap: () {
                      Navigator.of(context).pop();
                      context.goNamed(MyPageScreen.routeName);
                      onPicked('마이페이지');
                    },
                  ),
                  SizedBox(height: 10.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
