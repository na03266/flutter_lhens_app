import 'package:flutter/material.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';
import '../theme/app_colors.dart';

// 임시 어댑터
class TextEditorAdapter extends StatelessWidget {
  final TextEditingController controller;
  final String? hint;
  final ValueChanged<String>? onChanged;

  const TextEditorAdapter({
    super.key,
    required this.controller,
    this.hint,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: null,
      expands: true,
      keyboardType: TextInputType.multiline,
      style: AppTextStyles.pr15.copyWith(color: AppColors.text),
      onChanged: onChanged,
      decoration: InputDecoration(
        isDense: true,
        hintText: hint,
        hintStyle: AppTextStyles.pr15.copyWith(color: AppColors.placeholder),
        border: InputBorder.none,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }
}
