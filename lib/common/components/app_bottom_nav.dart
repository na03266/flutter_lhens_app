// common/components/app_bottom_nav.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lhens_app/common/components/feedback/press_scale.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_shadows.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';
import 'package:lhens_app/gen/assets.gen.dart';

class AppBottomNav extends StatelessWidget {
  final VoidCallback onTapLeft1, onTapLeft2, onTapRight1, onTapRight2, onTapCenter;
  final double fabDiameter, topGap, contentHeight, minBottomGap;

  const AppBottomNav({
    super.key,
    required this.onTapLeft1,
    required this.onTapLeft2,
    required this.onTapRight1,
    required this.onTapRight2,
    required this.onTapCenter,
    this.fabDiameter = 60,
    this.topGap = 2,
    this.contentHeight = 56,
    this.minBottomGap = 8,
  });

  @override
  Widget build(BuildContext context) {
    final inset = MediaQuery.of(context).padding.bottom;
    final bottomGap = (inset > 0 ? inset : minBottomGap).h;
    final barHeight = topGap.h + contentHeight.h + bottomGap;

    return SizedBox(
      height: barHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // 바 배경
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(14.r)),
                border: Border.all(color: AppColors.subtle, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.text.withValues(alpha: 0.15),
                    blurRadius: 6,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              padding: EdgeInsets.only(top: topGap.h, bottom: bottomGap),
              child: Row(
                children: [
                  _item('위험신고', Assets.icons.tabs.danger, onTapLeft1),
                  _item('커뮤니케이션', Assets.icons.tabs.chat, onTapLeft2),
                  SizedBox(width: fabDiameter.w), // FAB 자리만 비워둠
                  _item('업무매뉴얼', Assets.icons.tabs.manual, onTapRight1),
                  _item('마이페이지', Assets.icons.tabs.my, onTapRight2),
                ],
              ),
            ),
          ),

          // FAB만 위로 겹치기
          Positioned(
            top: -(fabDiameter.h / 4),
            left: 0,
            right: 0,
            child: Center(
              child: PressScale(
                onTap: onTapCenter,
                child: Container(
                  width: fabDiameter.w,
                  height: fabDiameter.w,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    boxShadow: AppShadows.homeButton,
                  ),
                  child: Center(
                    child: Assets.icons.tabs.home.svg(
                      width: 32.w,
                      height: 32.w,
                      colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _item(String label, SvgGenImage icon, VoidCallback onTap) {
    final iconSize = 22.w;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: SizedBox(
          height: contentHeight.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon.svg(
                width: iconSize,
                height: iconSize,
                colorFilter: ColorFilter.mode(AppColors.text, BlendMode.srcIn),
              ),
              SizedBox(height: 6.h),
              // 높이 부족 오버플로우 방지
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  style: AppTextStyles.pm12.copyWith(color: AppColors.text),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}