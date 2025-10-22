import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';

class TextSizer extends StatelessWidget {
  final double value; // 1.0 = 기본
  final ValueChanged<double> onChanged;
  final double min;
  final double max;
  final double step;

  const TextSizer({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0.8,
    this.max = 1.4,
    this.step = 0.1,
  });

  void _dec() {
    final v = value - step;
    onChanged(v < min ? min : double.parse(v.toStringAsFixed(2)));
  }

  void _inc() {
    final v = value + step;
    onChanged(v > max ? max : double.parse(v.toStringAsFixed(2)));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32.h,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(4.r),
        color: AppColors.white,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _IconGroup(label: '가', icon: '−', onTap: _dec, isSmall: true),
          Container(width: 1, height: double.infinity, color: AppColors.border),
          _IconGroup(label: '가', icon: '+', onTap: _inc, isSmall: false),
        ],
      ),
    );
  }
}

class _IconGroup extends StatelessWidget {
  final String label;
  final String icon;
  final VoidCallback onTap;
  final bool isSmall;

  const _IconGroup({
    required this.label,
    required this.icon,
    required this.onTap,
    required this.isSmall,
  });

  @override
  Widget build(BuildContext context) {
    final labelStyle = isSmall
        ? AppTextStyles.pm13.copyWith(color: AppColors.textSec)
        : AppTextStyles.pm14.copyWith(color: AppColors.textSec);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        child: Row(
          children: [
            Text(label, style: labelStyle),
            SizedBox(width: 6.w),
            Text(icon, style: AppTextStyles.psb14),
          ],
        ),
      ),
    );
  }
}
