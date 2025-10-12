// lib/common/components/inputs/app_text_field.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';

class AppTextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final bool isPassword;
  final bool showClear;
  final bool locked; // 입력/터치 차단
  final bool dimOnLocked; // 🔸 잠금 시 톤다운 여부 (배경/텍스트 or 투명도만)

  final TextEditingController? controller;
  final List<TextInputFormatter>? formatters;
  final TextInputType? keyboard;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;
  final double? height;
  final TextAlign textAlign;
  final TextAlignVertical textAlignVertical;

  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.isPassword = false,
    this.showClear = false,
    this.controller,
    this.formatters,
    this.keyboard,
    this.textInputAction,
    this.onSubmitted,
    this.onChanged,
    this.locked = false,
    this.dimOnLocked = true,
    this.height,
    this.textAlign = TextAlign.left,
    this.textAlignVertical = TextAlignVertical.center,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late final TextEditingController _c;
  late final FocusNode _focus;
  bool _obscure = false;

  @override
  void initState() {
    super.initState();
    _c = widget.controller ?? TextEditingController();
    _focus = FocusNode();
    _obscure = widget.isPassword;
    _c.addListener(_markDirty);
    _focus.addListener(_markDirty);
  }

  @override
  void dispose() {
    _c.removeListener(_markDirty);
    _focus.removeListener(_markDirty);
    if (widget.controller == null) _c.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _markDirty() {
    if (mounted) setState(() {});
  }

  Widget _iconButton(IconData icon, VoidCallback onTap) => GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: onTap,
    child: SizedBox(
      width: 24.w,
      height: 24.w,
      child: Icon(icon, size: 18.w, color: AppColors.borderStrong),
    ),
  );

  Widget _trailing({required bool showClearNow}) {
    if (!(showClearNow || widget.isPassword)) return const SizedBox.shrink();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showClearNow)
          _iconButton(Icons.close, () {
            _c.clear();
            _focus.requestFocus();
          }),
        if (showClearNow && widget.isPassword) SizedBox(width: 8.w),
        if (widget.isPassword)
          _iconButton(
            _obscure ? Icons.visibility_off : Icons.visibility,
                () => setState(() => _obscure = !_obscure),
          ),
      ],
    );
  }

  Widget _noMenu(BuildContext _, EditableTextState __) => const SizedBox.shrink();

  @override
  Widget build(BuildContext context) {
    final locked = widget.locked;
    final dim = widget.dimOnLocked;
    _focus.canRequestFocus = !locked;

    final hasText = _c.text.isNotEmpty;
    final showClearNow = widget.showClear && _focus.hasFocus && hasText && !locked;
    final borderColor =
    (_focus.hasFocus && !locked) ? AppColors.primary : AppColors.border;
    final hint = widget.hint ?? widget.label;
    final h = widget.height ?? 48.h;

    // 🔸 배경/텍스트/투명도 조정
    final bgColor = (locked && dim) ? AppColors.surface : AppColors.white;
    final textColor = (locked && dim) ? AppColors.textTer : AppColors.text;
    final opacity = locked
        ? (dim ? 0.6 : 0.6) // dimOnLocked=false → 투명도만 낮춤
        : 1.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Text(widget.label!, style: AppTextStyles.pm14),
          ),
        AnimatedOpacity(
          duration: const Duration(milliseconds: 150),
          opacity: opacity,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: borderColor, width: 1),
            ),
            height: h,
            padding: EdgeInsets.only(left: 16.w, right: 12.w),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _c,
                    focusNode: _focus,
                    readOnly: locked,
                    enabled: !locked,
                    enableInteractiveSelection: !locked,
                    contextMenuBuilder: locked ? _noMenu : null,
                    keyboardType: widget.keyboard,
                    inputFormatters: widget.formatters,
                    textInputAction: widget.textInputAction,
                    onSubmitted: locked ? null : widget.onSubmitted,
                    onChanged: locked ? null : widget.onChanged,
                    obscureText: widget.isPassword ? _obscure : false,
                    autocorrect: false,
                    enableSuggestions: false,
                    showCursor: !locked,
                    cursorColor: AppColors.secondary,
                    cursorWidth: 1.4,
                    cursorHeight: 18.h,
                    style: AppTextStyles.pr15.copyWith(color: textColor),
                    textAlign: widget.textAlign,
                    textAlignVertical: widget.textAlignVertical,
                    decoration: InputDecoration(
                      hintText: hint,
                      hintStyle: AppTextStyles.pr15.copyWith(
                        color: AppColors.placeholder,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                if (!locked) _trailing(showClearNow: showClearNow),
              ],
            ),
          ),
        ),
      ],
    );
  }
}