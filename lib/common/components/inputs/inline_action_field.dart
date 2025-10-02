import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../feedback/press_scale.dart';

/// 댓글용(입력 가능) / 선택용(읽기전용+검색) 두 모드를 지원
enum InlineActionVariant { comment, picker }

class InlineActionField extends StatelessWidget {
  // 공통
  final InlineActionVariant variant;
  final String actionText; // 버튼 라벨. 기본값은 variant에 따라 자동
  final VoidCallback onAction;

  // comment 모드(입력)
  final TextEditingController? controller;
  final String? hint;

  // picker 모드(라벨+탭 이동)
  final String? label;
  final VoidCallback? onTap; // picker일 때 전체 영역 탭 콜백

  const InlineActionField({
    super.key,
    required this.variant,
    required this.onAction,
    this.actionText = '',
    this.controller,
    this.hint,
    this.label,
    this.onTap,
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
            _SmallActionButton(label: btnLabel, onTap: onAction),
          ],
        ),
      ),
    );
  }

  Widget _buildMain() {
    if (_isComment) {
      return TextField(
        controller: controller,
        textInputAction: TextInputAction.done,
        style: AppTextStyles.pr15.copyWith(color: AppColors.text),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTextStyles.pr15.copyWith(color: AppColors.placeholder),
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
      );
    }
    // picker: 라벨(진한 텍스트)
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
