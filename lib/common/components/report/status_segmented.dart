import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lhens_app/common/components/feedback/press_scale.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_shadows.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';

enum ReportStatus { received, processing, done }

class StatusSegmented extends StatelessWidget {
  final ReportStatus value;
  final ValueChanged<ReportStatus>? onChanged;
  final List<ReportStatus> items;

  const StatusSegmented({
    super.key,
    required this.value,
    required this.onChanged,
    this.items = const [
      ReportStatus.received,
      ReportStatus.processing,
      ReportStatus.done,
    ],
  });

  String _label(ReportStatus s) => switch (s) {
    ReportStatus.received => '접수',
    ReportStatus.processing => '처리중',
    ReportStatus.done => '완료',
  };

  @override
  Widget build(BuildContext context) {
    final disabled = onChanged == null;
    final sel = [for (final s in items) s == value];

    return Container(
      height: 48.h,
      padding: EdgeInsets.all(2.w),
      decoration: ShapeDecoration(
        color: AppColors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: AppColors.border),
          borderRadius: BorderRadius.circular(9.r),
        ),
      ),
      child: Row(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            Expanded(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  if (i != items.length - 1 && !sel[i] && !sel[i + 1])
                    Positioned(
                      right: 0,
                      top: 12.h,
                      bottom: 12.h,
                      child: Container(
                        width: 1,
                        color: AppColors.border.withValues(alpha: 0.5),
                      ),
                    ),
                  _Segment(
                    label: _label(items[i]),
                    selected: sel[i],
                    onTap: disabled ? null : () => onChanged?.call(items[i]),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  const _Segment({required this.label, required this.selected, this.onTap});

  @override
  Widget build(BuildContext context) {
    final base = TextStyle(
      fontSize: AppTextStyles.psb14.fontSize,
      fontWeight: AppTextStyles.psb14.fontWeight,
    );

    Widget chip(bool sel) {
      final textColor = sel ? AppColors.text : AppColors.textTer;
      final body = Container(
        height: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          style: base.copyWith(color: textColor),
          child: Center(child: Text(label)),
        ),
      );

      if (!sel) return body;

      return Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: -1.5,
            right: -1.5,
            top: -1.5,
            bottom: -1.5,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(7.r),
                border: Border.all(width: 1.5, color: AppColors.secAccent),
                boxShadow: AppShadows.soft,
              ),
            ),
          ),
          body,
        ],
      );
    }

    return PressScale(
      pressedScale: 0.985,
      downDuration: const Duration(milliseconds: 80),
      upDuration: const Duration(milliseconds: 150),
      onTap: onTap,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 150),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeOut,
        transitionBuilder: (c, a) => FadeTransition(opacity: a, child: c),
        child: selected
            ? KeyedSubtree(key: const ValueKey(true), child: chip(true))
            : KeyedSubtree(key: const ValueKey(false), child: chip(false)),
      ),
    );
  }
}
