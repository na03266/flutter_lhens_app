import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lhens_app/common/components/inputs/inline_action_field.dart';
import 'package:lhens_app/common/components/target_chip_section.dart';

class TargetGroup<T> {
  final String label;
  final List<T> items;

  const TargetGroup({required this.label, required this.items});
}

class TargetSection<T> extends StatelessWidget {
  final VoidCallback onSearch; // 선택 바/버튼 탭
  final List<TargetGroup<T>> groups; // 라벨별 칩 그룹
  final List<T> fixed; // 고정 칩(삭제 불가)
  final String Function(T) getText; // T -> 텍스트
  final void Function(String group, T item)? onRemove;
  final String label; // 선택 바 라벨
  final String actionText; // 버튼 텍스트
  final double? spacing; // 바-칩 간격

  const TargetSection({
    super.key,
    required this.onSearch,
    required this.groups,
    required this.getText,
    this.fixed = const [],
    this.onRemove,
    this.label = '알림 대상 선택',
    this.actionText = '검색',
    this.spacing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InlineActionField(
          variant: InlineActionVariant.picker,
          label: label,
          actionText: actionText,
          onAction: onSearch,
          onTap: onSearch,
        ),
        SizedBox(height: (spacing ?? 8).h),
        TargetChipsSection<T>(
          groups: groups,
          fixed: fixed,
          getText: getText,
          onRemove: onRemove,
        ),
      ],
    );
  }
}
