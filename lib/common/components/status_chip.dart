import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';

enum StatusChipType {
  received, // 접수
  processing, // 처리중
  done, // 완료
  participate, // 참여
  notParticipate, // 미참여
  realname, // 실명
  anonymous, // 익명
  tag, // 이름 태그 + x
  fixed, // 고정값 (삭제불가)
}

class StatusChip extends StatelessWidget {
  final StatusChipType type;
  final String? text;
  final VoidCallback? onRemove;

  const StatusChip({super.key, required this.type, this.text, this.onRemove});

  @override
  Widget build(BuildContext context) {
    final style = _styleOf(type);

    final textStyle = switch (type) {
      StatusChipType.tag => AppTextStyles.pm13.copyWith(color: style.fg),
      StatusChipType.fixed => AppTextStyles.pm13.copyWith(color: style.fg),
      _ => AppTextStyles.psb12.copyWith(color: style.fg),
    };

    return Container(
      height: 24.h,
      padding: EdgeInsets.symmetric(
        horizontal: 8.w,
        vertical: 4.h,
      ).copyWith(right: style.isTag ? 4.w : 8.w),
      decoration: BoxDecoration(
        color: style.bg,
        borderRadius: BorderRadius.circular(8.r),
        border: style.borderColor == null
            ? null
            : Border.all(color: style.borderColor!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text ?? style.fallbackLabel, style: textStyle),
          if (style.isTag) ...[
            SizedBox(width: 4.w),
            _CloseBtn(onTap: onRemove),
          ],
        ],
      ),
    );
  }

  _ChipStyle _styleOf(StatusChipType t) {
    switch (t) {
      case StatusChipType.received:
        return _ChipStyle(
          bg: AppColors.primarySoft,
          borderColor: AppColors.primary,
          fg: AppColors.primaryText,
          fallbackLabel: '접수',
        );
      case StatusChipType.processing:
        return _ChipStyle(
          bg: AppColors.navySoft,
          borderColor: AppColors.navy,
          fg: AppColors.navy,
          fallbackLabel: '처리중',
        );
      case StatusChipType.done:
        return _ChipStyle(
          bg: AppColors.subtle,
          borderColor: AppColors.border,
          fg: AppColors.muted,
          fallbackLabel: '완료',
        );
      case StatusChipType.participate:
        return _ChipStyle(
          bg: AppColors.primary,
          borderColor: null,
          fg: AppColors.white,
          fallbackLabel: '참여',
        );
      case StatusChipType.notParticipate:
        return _ChipStyle(
          bg: AppColors.navy,
          borderColor: null,
          fg: AppColors.white,
          fallbackLabel: '미참여',
        );
      case StatusChipType.realname:
      case StatusChipType.anonymous:
        return _ChipStyle(
          bg: AppColors.white,
          borderColor: AppColors.textSec,
          fg: AppColors.muted,
          fallbackLabel: t == StatusChipType.realname ? '실명' : '익명',
        );
      case StatusChipType.tag:
        return _ChipStyle(
          bg: AppColors.subtle,
          borderColor: null,
          fg: AppColors.textSec,
          fallbackLabel: '이름',
          isTag: true,
        );
      case StatusChipType.fixed:
        return _ChipStyle(
          bg: AppColors.primarySoft,
          borderColor: null,
          fg: AppColors.textSec,
          fallbackLabel: '고정',
        );
    }
  }
}

class _ChipStyle {
  _ChipStyle({
    required this.bg,
    required this.fg,
    required this.fallbackLabel,
    this.borderColor,
    this.isTag = false,
  });

  final Color bg;
  final Color fg;
  final String fallbackLabel;
  final Color? borderColor;
  final bool isTag;
}

class _CloseBtn extends StatelessWidget {
  const _CloseBtn({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        width: 16.w,
        height: 16.w,
        child: Icon(Icons.close, size: 12.w, color: AppColors.textTer),
      ),
    );
  }
}
