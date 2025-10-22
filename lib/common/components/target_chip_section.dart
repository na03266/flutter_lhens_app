import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lhens_app/user/component/target_section.dart';
import 'package:lhens_app/common/components/status_chip.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';

class TargetChipsSection<T> extends StatelessWidget {
  final List<TargetGroup<T>> groups; // 라벨별 그룹 목록
  final List<T> fixed; // 고정 칩 (삭제 불가)
  final String Function(T) getText; // 아이템 → 라벨 변환 함수
  final void Function(String groupLabel, T item)? onRemove; // 칩 제거 콜백
  final String emptyText; // 그룹이 비었을 때 표시할 문구
  final double? labelWidth; // 라벨 영역 고정 너비
  final double? spacing; // 칩 간 간격
  final double? runSpacing; // 칩 줄바꿈 간 간격
  final bool showBetweenDivider; // 그룹 사이 구분선 표시 여부

  const TargetChipsSection({
    super.key,
    required this.groups,
    required this.getText,
    this.fixed = const [],
    this.onRemove,
    this.emptyText = '선택 없음',
    this.labelWidth,
    this.spacing,
    this.runSpacing,
    this.showBetweenDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final lw = (labelWidth ?? 32).w;
    final sp = (spacing ?? 8).w;
    final rsp = (runSpacing ?? 8).h;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (fixed.isNotEmpty) ...[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Wrap(
              spacing: sp,
              runSpacing: rsp,
              children: fixed
                  .map(
                    (t) => StatusChip(
                      type: StatusChipType.fixed,
                      text: getText(t),
                    ),
                  )
                  .toList(),
            ),
          ),
          const _DashedDivider(),
        ],
        for (var i = 0; i < groups.length; i++) ...[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: lw,
                  child: Padding(
                    padding: EdgeInsets.only(top: 4.h),
                    child: Text(groups[i].label, style: AppTextStyles.psb12),
                  ),
                ),
                Expanded(
                  child: _ChipsWrap<T>(
                    values: groups[i].items,
                    getText: getText,
                    spacing: sp,
                    runSpacing: rsp,
                    emptyText: emptyText,
                    onRemove: onRemove == null
                        ? null
                        : (item) => onRemove!(groups[i].label, item),
                  ),
                ),
              ],
            ),
          ),
          if (showBetweenDivider && i != groups.length - 1)
            const _DashedDivider(),
        ],
      ],
    );
  }
}

class _ChipsWrap<T> extends StatelessWidget {
  const _ChipsWrap({
    required this.values,
    required this.getText,
    required this.spacing,
    required this.runSpacing,
    required this.emptyText,
    this.onRemove,
  });

  final List<T> values;
  final String Function(T) getText;
  final double spacing;
  final double runSpacing;
  final String emptyText;
  final ValueChanged<T>? onRemove;

  @override
  Widget build(BuildContext context) {
    if (values.isEmpty) {
      return SizedBox(
        height: 24, // 칩 높이와 맞춤
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 2),
            child: Text(
              emptyText,
              style: AppTextStyles.pr14.copyWith(color: AppColors.placeholder),
            ),
          ),
        ),
      );
    }
    return Wrap(
      spacing: spacing,
      runSpacing: runSpacing,
      children: [
        for (final v in values)
          StatusChip(
            type: StatusChipType.tag,
            text: getText(v),
            onRemove: onRemove == null ? null : () => onRemove!(v),
          ),
      ],
    );
  }
}

class _DashedDivider extends StatelessWidget {
  const _DashedDivider();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, c) {
        const w = 4.0, gap = 4.0;
        final count = (c.maxWidth / (w + gap)).floor();
        return SizedBox(
          height: 1,
          child: Row(
            children: List.generate(
              count,
              (_) => Padding(
                padding: const EdgeInsets.only(right: gap),
                child: Container(width: w, height: 1, color: AppColors.border),
              ),
            ),
          ),
        );
      },
    );
  }
}
