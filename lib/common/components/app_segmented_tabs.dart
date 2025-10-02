import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';

class AppSegmentedTabs extends StatelessWidget {
  final int index; // 0 전체
  final ValueChanged<int> onChanged;
  final List<String> rightTabs;
  final int? badgeCount;
  final double? horizontalPadding;
  final double? height;
  final double? underlineWidth;

  const AppSegmentedTabs({
    super.key,
    required this.index,
    required this.onChanged,
    this.rightTabs = const ['공개', '요청(비공개)'],
    this.badgeCount,
    this.horizontalPadding,
    this.height,
    this.underlineWidth,
  });

  @override
  Widget build(BuildContext context) {
    final pad = (horizontalPadding ?? 16.w)
        .clamp(0, double.infinity)
        .toDouble();
    final h = (height ?? 44.h).clamp(36.h, 64.h).toDouble();
    final ulW = (underlineWidth ?? 120.w).clamp(56.w, 220.w).toDouble();

    final screenW = MediaQuery.of(context).size.width;
    final usable = (screenW - pad * 2).clamp(1.0, double.infinity).toDouble();
    final segW = usable / 3;
    final ulLeft = pad + segW * index + (segW - ulW) / 2;

    Widget tab(String label, int i, {bool showBadge = false}) {
      final selected = index == i;
      final base = selected ? AppTextStyles.psb15 : AppTextStyles.pm15;

      return Expanded(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => onChanged(i),
          child: SizedBox(
            height: h,
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: base.copyWith(
                      color: selected ? AppColors.text : AppColors.textSec,
                    ),
                  ),
                  if (showBadge && (badgeCount ?? 0) > 0) ...[
                    SizedBox(width: 6.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        '${badgeCount!}',
                        style: AppTextStyles.pb12.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: h,
      child: Stack(
        children: [
          // 기본선
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(height: 1, color: AppColors.border),
            ),
          ),
          // 탭 라벨 영역
          Padding(
            padding: EdgeInsets.symmetric(horizontal: pad),
            child: Row(
              children: [
                tab('전체', 0, showBadge: badgeCount != null),
                tab(rightTabs[0], 1),
                tab(rightTabs[1], 2),
              ],
            ),
          ),
          // 강조선
          Positioned(
            left: ulLeft,
            bottom: 0,
            width: ulW,
            child: Container(height: 2, color: AppColors.text),
          ),
        ],
      ),
    );
  }
}
