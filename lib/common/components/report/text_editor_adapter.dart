import 'package:flutter/material.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';
import 'package:lhens_app/common/theme/app_colors.dart';

class TextEditorAdapter extends StatelessWidget {
  final TextEditingController controller;
  final String? hint;
  final ValueChanged<String>? onChanged;
  final bool locked;
  final bool dimOnLocked;

  const TextEditorAdapter({
    super.key,
    required this.controller,
    this.hint,
    this.onChanged,
    this.locked = false,
    this.dimOnLocked = true,
  });

  Widget _noMenu(BuildContext _, EditableTextState __) =>
      const SizedBox.shrink();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      enabled: !locked,
      readOnly: locked,
      maxLines: null,
      expands: true,
      keyboardType: TextInputType.multiline,
      enableInteractiveSelection: !locked,
      contextMenuBuilder: locked ? _noMenu : null,
      showCursor: !locked,
      cursorColor: AppColors.secondary,
      cursorWidth: 1.4,
      cursorHeight: 18,
      style: AppTextStyles.pr15.copyWith(
        color: locked
            ? (dimOnLocked ? AppColors.textTer : AppColors.text)
            : AppColors.text,
      ),
      onChanged: locked ? null : onChanged,
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
