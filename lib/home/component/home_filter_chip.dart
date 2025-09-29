import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';

enum HomeFilter { all, edu, event }

class HomeFilterChip extends StatelessWidget {
  const HomeFilterChip({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final HomeFilter selected;
  final ValueChanged<HomeFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _Chip(
          label: '전체',
          selected: selected == HomeFilter.all,
          onTap: () => onChanged(HomeFilter.all),
        ),
        SizedBox(width: 8.w),
        _Chip(
          label: '교육',
          selected: selected == HomeFilter.edu,
          onTap: () => onChanged(HomeFilter.edu),
        ),
        SizedBox(width: 8.w),
        _Chip(
          label: '행사',
          selected: selected == HomeFilter.event,
          onTap: () => onChanged(HomeFilter.event),
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final baseStyle = AppTextStyles.pb14;
    final textColor = selected ? AppColors.secondary : AppColors.textTer;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: selected ? AppColors.secondary : AppColors.textTer,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: baseStyle.copyWith(color: textColor),
        ),
      ),
    );
  }
}
