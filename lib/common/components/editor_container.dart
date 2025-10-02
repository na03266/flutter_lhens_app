import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class EditorContainer extends StatefulWidget {
  final double height; // 고정 높이
  final Widget child;
  final bool showCounter;
  final String? counterText;
  final EdgeInsets? contentPadding;

  const EditorContainer({
    super.key,
    required this.height,
    required this.child,
    this.showCounter = false,
    this.counterText,
    this.contentPadding,
  });

  @override
  State<EditorContainer> createState() => _EditorContainerState();
}

class _EditorContainerState extends State<EditorContainer> {
  late final FocusScopeNode _scope;
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _scope = FocusScopeNode()..addListener(_onFocus);
  }

  void _onFocus() => setState(() => _focused = _scope.hasFocus);

  @override
  void dispose() {
    _scope.removeListener(_onFocus);
    _scope.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pad =
        widget.contentPadding ?? EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 4.h);
    return SizedBox(
      height: widget.height.h,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: _focused ? AppColors.primary : AppColors.border,
            width: 1,
          ),
        ),
        child: FocusScope(
          node: _scope,
          child: Column(
            children: [
              Expanded(
                child: Padding(padding: pad, child: widget.child),
              ),
              if (widget.showCounter)
                Padding(
                  padding: EdgeInsets.only(right: 15.w, bottom: 15.h),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      widget.counterText ?? '',
                      style: AppTextStyles.pr13.copyWith(
                        color: AppColors.placeholder,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
