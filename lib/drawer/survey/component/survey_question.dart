import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_shadows.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';
import 'package:lhens_app/drawer/survey/model/join_survey_dto.dart';
import 'package:lhens_app/drawer/survey/model/survey_question_model.dart';
import 'package:lhens_app/gen/assets.gen.dart';

enum SurveyQuestionType { multi, single, text }

class SurveyQuestion extends StatefulWidget {
  final SurveyQuestionModel model;
  final double spacing;
  final Set<JoinSurveyDto> selectedItems;
  final Function(bool, int, int) onSelected;

  // 텍스트 답변을 부모에게 알려주는 콜백
  final void Function(int sqId, String answer)? onTextChanged; // 주관식
  final void Function(int sqId, int soId, String answer)?
  onEtcTextChanged; // 라디오+기타

  final int minLines;

  const SurveyQuestion({
    super.key,
    required this.model,
    this.spacing = 8.0,
    required this.selectedItems,
    required this.onSelected,
    this.onTextChanged,
    this.onEtcTextChanged,
    this.minLines = 3,
  });

  @override
  State<SurveyQuestion> createState() => _SurveyQuestionState();
}

class _SurveyQuestionState extends State<SurveyQuestion> {
  late final TextEditingController _textController; // 주관식
  late final TextEditingController _etcController; // 기타 입력

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _etcController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    _etcController.dispose();
    super.dispose();
  }

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
            if (widget.model.sqType == SQType.checkbox) _buildCheckBox(),
            if (widget.model.sqType == SQType.radio) _buildRadio(),
            if (widget.model.sqType == SQType.radio_text) _buildRadio(),
            if (widget.model.sqType == SQType.text) _buildText(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        if (widget.model.sqRequired == 1) ...[
          Text(
            '*',
            style: AppTextStyles.pr16.copyWith(color: AppColors.danger),
          ),
          SizedBox(width: 4.w),
        ],
        Text(
          widget.model.sqTitle,
          style: AppTextStyles.pm16.copyWith(color: AppColors.text),
        ),
        if (widget.model.sqType == SQType.checkbox)
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

  Widget _buildCheckBox() {
    final options = widget.model.options;

    return Column(
      children: [
        for (int i = 0; i < options.length; i++)
          Padding(
            padding: EdgeInsets.only(
              bottom: i == options.length - 1 ? 0 : widget.spacing.h,
            ),
            child: _OptionTile(
              label: options[i].soText,
              selected: widget.selectedItems
                  .map((e) => e.soId)
                  .toList()
                  .contains(options[i].soId),
              onTap: () {
                final isSelected = widget.selectedItems
                    .map((e) => e.soId)
                    .toList()
                    .contains(options[i].soId);
                widget.onSelected(
                  !isSelected,
                  options[i].sqId,
                  options[i].soId,
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildRadio() {
    final options = widget.model.options;

    return Column(
      children: [
        for (int i = 0; i < options.length; i++)
          Padding(
            padding: EdgeInsets.only(
              bottom: i == options.length - 1 ? 0 : widget.spacing.h,
            ),
            child: options[i].soHasInput == 1
                // 기타 텍스트 옵션
                ? _EtcOptionTile(
                    label: options[i].soText,
                    controller: _etcController,
                    selected: widget.selectedItems
                        .map((e) => e.soId)
                        .contains(options[i].soId),
                    onTap: () {
                      // 기타 옵션 선택 처리
                      widget.onSelected(true, options[i].sqId, options[i].soId);
                    },
                    onChanged: (text) {
                      widget.onEtcTextChanged?.call(
                        options[i].sqId,
                        options[i].soId,
                        text.trim(),
                      );
                    },
                  )
                // 일반 라디오 옵션
                : _OptionTile(
                    label: options[i].soText,
                    selected: widget.selectedItems
                        .map((e) => e.soId)
                        .contains(options[i].soId),
                    onTap: () {
                      final isSelected = widget.selectedItems
                          .map((e) => e.soId)
                          .contains(options[i].soId);

                      widget.onSelected(
                        !isSelected,
                        options[i].sqId,
                        options[i].soId,
                      );
                    },
                  ),
          ),
      ],
    );
  }

  Widget _buildText() {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: (widget.minLines * 24).h),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: AppColors.subtle,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: TextField(
          controller: _textController,
          maxLines: null,
          minLines: widget.minLines,
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
          onChanged: (value) {
            widget.onTextChanged?.call(widget.model.sqId, value.trim());
          },
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
    required this.selected,
    required this.onTap,
    required this.onChanged,
  });

  final bool selected;
  final String label;
  final TextEditingController? controller;
  final VoidCallback onTap;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final icon = selected
        ? Assets.icons.checkCirclePrimary
        : Assets.icons.checkCircle;

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
          if(selected)
          SizedBox(height: 8.h),
          if(selected)
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
