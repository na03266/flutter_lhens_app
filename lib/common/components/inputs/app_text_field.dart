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
  final bool readOnly;
  final TextEditingController? controller;
  final List<TextInputFormatter>? formatters;
  final TextInputType? keyboard;
  final TextInputAction? textInputAction;
  final void Function(String)? onSubmitted;
  final void Function(String)? onChanged;
  final double? height;

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
    this.readOnly = false,
    this.height,
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
    _c.addListener(_update);
    _focus.addListener(_update);
  }

  @override
  void dispose() {
    _c.removeListener(_update);
    _focus.removeListener(_update);
    if (widget.controller == null) _c.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _update() {
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

  @override
  Widget build(BuildContext context) {
    final hasText = _c.text.isNotEmpty;
    final showClearNow = widget.showClear && _focus.hasFocus && hasText;
    final borderColor = _focus.hasFocus ? AppColors.primary : AppColors.border;
    final hint = widget.hint ?? widget.label;
    final h = widget.height ?? 48.h;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Text(widget.label!, style: AppTextStyles.pm14),
          ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          height: h,
          padding: EdgeInsets.only(left: 16.w, right: 12.w),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: borderColor, width: 1),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _c,
                  focusNode: _focus,
                  readOnly: widget.readOnly,
                  keyboardType: widget.keyboard,
                  inputFormatters: widget.formatters,
                  textInputAction: widget.textInputAction,
                  onSubmitted: widget.onSubmitted,
                  onChanged: widget.onChanged,
                  obscureText: widget.isPassword ? _obscure : false,
                  autocorrect: false,
                  enableSuggestions: false,
                  style: AppTextStyles.pr15.copyWith(color: AppColors.text),
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
              _trailing(showClearNow: showClearNow),
            ],
          ),
        ),
      ],
    );
  }
}
