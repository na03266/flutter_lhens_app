import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';
import 'package:lhens_app/common/components/feedback/press_scale.dart';

enum InlineActionVariant { comment, picker }

class InlineActionField extends StatelessWidget {
  final InlineActionVariant variant;
  final String actionText;
  final VoidCallback onAction;
  final TextEditingController? controller;
  final String? hint;
  final String? label;
  final VoidCallback? onTap;
  final FocusNode? focusNode;

  const InlineActionField({
    super.key,
    required this.variant,
    required this.onAction,
    this.actionText = '',
    this.controller,
    this.hint,
    this.label,
    this.onTap,
    this.focusNode,
  });

  bool get _isComment => variant == InlineActionVariant.comment;

  @override
  Widget build(BuildContext context) {
    final btnLabel = (actionText.isEmpty)
        ? (_isComment ? '등록' : '검색')
        : actionText;

    return InkWell(
      onTap: _isComment ? null : onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        height: 48.h,
        padding: EdgeInsets.only(left: 16.w, right: 8.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.border, width: 1),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            Expanded(child: _buildMain()),
            SizedBox(width: 10.w),
            _SmallActionButton(label: btnLabel, onTap: onAction),
          ],
        ),
      ),
    );
  }

  Widget _buildMain() {
    if (_isComment) {
      return TextField(
        focusNode: focusNode,
        controller: controller,
        textInputAction: TextInputAction.done,
        style: AppTextStyles.pr15.copyWith(color: AppColors.text),
        cursorColor: AppColors.secondary,
        cursorWidth: 1.4,
        cursorHeight: 18.h,
        scrollPadding: EdgeInsets.zero,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTextStyles.pr15.copyWith(color: AppColors.placeholder),
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
      );
    }
    return Text(
      label ?? '',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: AppTextStyles.pm15.copyWith(color: AppColors.text),
    );
  }
}

class _SmallActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _SmallActionButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return PressScale(
      onTap: onTap,
      child: Container(
        height: 32.h,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          color: AppColors.secondary,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Center(
          child: Text(
            label,
            style: AppTextStyles.pm12.copyWith(color: AppColors.white),
          ),
        ),
      ),
    );
  }
}
