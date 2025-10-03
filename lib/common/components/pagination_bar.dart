import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';

class PaginationBar extends StatelessWidget {
  final int currentPage; // 1-based
  final int totalPages;
  final ValueChanged<int> onPageChanged;
  final int window; // 보여줄 숫자 버튼 개수
  final double? spacing;
  final bool showFirstLast;

  const PaginationBar({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
    this.window = 2,
    this.spacing,
    this.showFirstLast = true,
  });

  @override
  Widget build(BuildContext context) {
    final gap = spacing ?? 12.w;
    final cur = currentPage.clamp(1, totalPages);
    final win = window.clamp(1, totalPages);

    final range = _calcWindow(cur, totalPages, win);
    final start = range.$1;
    final end = range.$2;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showFirstLast) ...[
          _IconBtn(
            icon: Icons.first_page,
            enabled: cur > 1,
            onTap: () => onPageChanged(1),
          ),
          SizedBox(width: gap),
        ],
        _IconBtn(
          icon: Icons.chevron_left,
          enabled: cur > 1,
          onTap: () => onPageChanged(cur - 1),
        ),
        SizedBox(width: gap),

        for (int p = start; p <= end; p++) ...[
          _NumberBtn(
            page: p,
            selected: p == cur,
            onTap: () => onPageChanged(p),
          ),
          if (p != end) SizedBox(width: gap),
        ],

        SizedBox(width: gap),
        _IconBtn(
          icon: Icons.chevron_right,
          enabled: cur < totalPages,
          onTap: () => onPageChanged(cur + 1),
        ),
        if (showFirstLast) ...[
          SizedBox(width: gap),
          _IconBtn(
            icon: Icons.last_page,
            enabled: cur < totalPages,
            onTap: () => onPageChanged(totalPages),
          ),
        ],
      ],
    );
  }

  (int, int) _calcWindow(int cur, int total, int win) {
    if (win <= 1) return (cur, cur);

    int start = cur - (win ~/ 2);
    start = start.clamp(1, (total - win + 1).clamp(1, total));
    int end = (start + win - 1).clamp(1, total);
    if (end - start + 1 < win) start = (end - win + 1).clamp(1, total);
    return (start, end);
  }
}

class _NumberBtn extends StatelessWidget {
  const _NumberBtn({
    required this.page,
    required this.selected,
    required this.onTap,
  });

  final int page;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final size = 44.w;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: selected ? null : onTap, // ✅ 현재 페이지면 탭 비활성화(선택)
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        padding: EdgeInsets.all(10.w),
        decoration: ShapeDecoration(
          color: selected ? AppColors.secondary : AppColors.white,
          shape: RoundedRectangleBorder(
            side: selected
                ? BorderSide.none
                : const BorderSide(width: 1, color: AppColors.border),
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: Text(
          '$page',
          style: AppTextStyles.pm14.copyWith(
            fontWeight: FontWeight.w600,
            color: selected ? AppColors.white : AppColors.text,
          ),
        ),
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  const _IconBtn({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final size = 44.w;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: enabled ? onTap : null,
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        padding: EdgeInsets.all(10.w),
        decoration: ShapeDecoration(
          color: AppColors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              color: enabled ? AppColors.border : AppColors.subtle,
            ),
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: Icon(
          icon,
          size: 16.w,
          color: enabled ? AppColors.text : AppColors.borderStrong,
        ),
      ),
    );
  }
}
