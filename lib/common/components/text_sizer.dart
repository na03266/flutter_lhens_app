import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';

class TextSizer extends StatelessWidget {
  final double value; // 1.0 기본
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
    final v = (value - step);
    onChanged(v < min ? min : double.parse(v.toStringAsFixed(2)));
  }

  void _inc() {
    final v = (value + step);
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
          // 왼쪽: 가 −
          Padding(
            padding: EdgeInsets.only(left: 8.w, right: 3.w),
            child: Row(
              children: [
                Text(
                  '가',
                  style: AppTextStyles.pm13.copyWith(color: AppColors.textSec),
                ),
                SizedBox(width: 2.w),
                _IconBtn(label: '−', onTap: _dec),
              ],
            ),
          ),

          // 가운데 구분선 (세로 전체)
          Container(width: 1, height: double.infinity, color: AppColors.border),

          // 오른쪽: 가 +
          Padding(
            padding: EdgeInsets.only(left: 8.w, right: 3.w),
            child: Row(
              children: [
                Text(
                  '가',
                  style: AppTextStyles.pm14.copyWith(color: AppColors.textSec),
                ),
                SizedBox(width: 2.w),
                _IconBtn(label: '+', onTap: _inc),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _IconBtn({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
        child: Text(label, style: AppTextStyles.psb14),
      ),
    );
  }
}
