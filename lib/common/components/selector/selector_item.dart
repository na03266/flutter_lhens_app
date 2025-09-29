import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';
import 'package:lhens_app/common/theme/app_colors.dart';

class SelectorItem extends StatelessWidget {
  final String text;
  final bool isSelected;
  final bool isLast;
  final VoidCallback onTap;

  const SelectorItem({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.surface : AppColors.white,
          border: isLast
              ? null
              : Border(bottom: BorderSide(color: AppColors.border, width: 1)),
        ),
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.pr15.copyWith(
            color: isSelected ? AppColors.secondary : AppColors.text,
          ),
        ),
      ),
    );
  }
}
