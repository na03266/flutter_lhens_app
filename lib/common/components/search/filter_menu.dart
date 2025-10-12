import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class FilterMenu<T> extends StatelessWidget {
  final double width;
  final List<T> items;
  final T? selected;
  final String Function(T) getLabel;
  final ValueChanged<T> onSelected;
  final double? maxHeight;

  const FilterMenu({
    super.key,
    required this.width,
    required this.items,
    required this.selected,
    required this.getLabel,
    required this.onSelected,
    this.maxHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 6,
      borderRadius: BorderRadius.circular(8.r),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: width,
          maxWidth: width,
          maxHeight: maxHeight ?? 240.h,
        ),
        child: ListView.separated(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: items.length,
          separatorBuilder: (_, __) =>
              const Divider(height: 1, color: AppColors.subtle),
          itemBuilder: (_, i) {
            final item = items[i];
            final isSel = item == selected;
            return InkWell(
              onTap: () => onSelected(item),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                child: Text(
                  getLabel(item),
                  style: AppTextStyles.pr15.copyWith(
                    color: isSel ? AppColors.primary : AppColors.text,
                    fontWeight: isSel ? FontWeight.w500 : null,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
