import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_shadows.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';
import 'package:lhens_app/gen/assets.gen.dart';

enum SurveyQuestionType { multi, single, text }

class SurveyQuestion extends StatelessWidget {
  final SurveyQuestionType type;
  final String title;
  final bool isRequired;
  final double spacing;
  final List<String>? options;
  final Set<int>? selectedIndexes;
  final void Function(Set<int> selected, String? etcText)? onMultiChanged;
  final bool enableEtc; // 마지막 항목 '기타'로 간주
  final TextEditingController? etcController;
  final int? selectedIndex;
  final void Function(int index)? onSingleChanged;
  final TextEditingController? textController;
  final int minLines;

  const SurveyQuestion({
    super.key,
    required this.type,
    required this.title,
    this.isRequired = false,
    this.spacing = 8.0,
    this.options,
    this.selectedIndexes,
    this.onMultiChanged,
    this.enableEtc = false,
    this.etcController,
    this.selectedIndex,
    this.onSingleChanged,
    this.textController,
    this.minLines = 3,
  });

  bool get _isMulti => type == SurveyQuestionType.multi;

  bool get _isSingle => type == SurveyQuestionType.single;

  bool get _isText => type == SurveyQuestionType.text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.white,
      padding: EdgeInsets.all(16.w),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: AppColors.bg,
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: AppShadows.subtle,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: 12.h),
            if (_isMulti) _buildMulti(),
            if (_isSingle) _buildSingle(),
            if (_isText) _buildText(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        if (isRequired) ...[
          Text(
            '*',
            style: AppTextStyles.pr16.copyWith(color: AppColors.danger),
          ),
          SizedBox(width: 4.w),
        ],
        Text(title, style: AppTextStyles.pm16.copyWith(color: AppColors.text)),
        if (_isMulti)
          Padding(
            padding: EdgeInsets.only(left: 4.w),
            child: Text(
              '(중복선택)',
              style: AppTextStyles.pm16.copyWith(color: AppColors.danger),
            ),
          ),
      ],
    );
  }

  Widget _buildMulti() {
    final opts = options ?? const [];
    final sel = (selectedIndexes ?? {}).toSet();
    final hasEtc = enableEtc && opts.isNotEmpty;
    final etcIdx = hasEtc ? opts.length - 1 : -1;

    return Column(
      children: [
        for (int i = 0; i < opts.length; i++)
          Padding(
            padding: EdgeInsets.only(
              bottom: i == opts.length - 1 ? 0 : spacing.h,
            ),
            child: (hasEtc && i == etcIdx && sel.contains(etcIdx))
                ? _EtcOptionTile(
                    label: opts[i],
                    controller: etcController,
                    onTap: () {
                      final next = sel.toSet()..remove(etcIdx);
                      onMultiChanged?.call(next, null);
                    },
                    onChanged: (text) => onMultiChanged?.call(sel, text.trim()),
                  )
                : _OptionTile(
                    label: opts[i],
                    selected: sel.contains(i),
                    onTap: () {
                      final next = sel.toSet();
                      next.contains(i) ? next.remove(i) : next.add(i);
                      onMultiChanged?.call(
                        next,
                        (hasEtc && i == etcIdx && next.contains(etcIdx))
                            ? etcController?.text.trim()
                            : null,
                      );
                    },
                  ),
          ),
      ],
    );
  }

  Widget _buildSingle() {
    final opts = options ?? const [];
    final cur = selectedIndex;
    final hasEtc = enableEtc && opts.isNotEmpty;
    final etcIdx = hasEtc ? opts.length - 1 : -1;

    return Column(
      children: [
        for (int i = 0; i < opts.length; i++)
          Padding(
            padding: EdgeInsets.only(
              bottom: i == opts.length - 1 ? 0 : spacing.h,
            ),
            child: (hasEtc && i == etcIdx && cur == etcIdx)
                ? _EtcOptionTile(
                    label: opts[i],
                    controller: etcController,
                    onTap: () => onSingleChanged?.call(-1),
                    onChanged: (text) =>
                        onMultiChanged?.call({etcIdx}, text.trim()),
                  )
                : _OptionTile(
                    label: opts[i],
                    selected: cur == i,
                    onTap: () => onSingleChanged?.call(i),
                  ),
          ),
      ],
    );
  }

  Widget _buildText() {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: (minLines * 24).h),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: AppColors.subtle,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: TextField(
          controller: textController,
          maxLines: null,
          minLines: minLines,
          cursorColor: AppColors.secondary,
          cursorWidth: 1.4,
          cursorHeight: 18.h,
          decoration: InputDecoration(
            isCollapsed: true,
            border: InputBorder.none,
            hintText: '내용을 입력하세요',
            hintStyle: AppTextStyles.pr15.copyWith(
              color: AppColors.placeholder,
            ),
          ),
          style: AppTextStyles.pr16.copyWith(color: AppColors.text),
        ),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final icon = selected
        ? Assets.icons.checkCirclePrimary
        : Assets.icons.checkCircle;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: AppColors.subtle,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 24.w,
              height: 24.w,
              child: icon.svg(width: 24.w, height: 24.w),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.pm16.copyWith(color: AppColors.text),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EtcOptionTile extends StatelessWidget {
  const _EtcOptionTile({
    required this.label,
    required this.controller,
    required this.onTap,
    required this.onChanged,
  });

  final String label;
  final TextEditingController? controller;
  final VoidCallback onTap;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.subtle,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTap,
            child: Row(
              children: [
                SizedBox(
                  width: 24.w,
                  height: 24.w,
                  child: Assets.icons.checkCirclePrimary.svg(
                    width: 24.w,
                    height: 24.w,
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    label,
                    style: AppTextStyles.pm16.copyWith(color: AppColors.text),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.border, width: 1),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 2.w, bottom: 6.h),
              child: TextField(
                controller: controller,
                onChanged: onChanged,
                cursorColor: AppColors.secondary,
                cursorWidth: 1.4,
                cursorHeight: 18.h,
                decoration: InputDecoration(
                  isCollapsed: true,
                  border: InputBorder.none,
                  hintText: '내용을 입력하세요',
                  hintStyle: AppTextStyles.pr15.copyWith(
                    color: AppColors.placeholder,
                  ),
                ),
                style: AppTextStyles.pr16.copyWith(color: AppColors.text),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
