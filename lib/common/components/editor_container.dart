import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class EditorContainer extends StatefulWidget {
  final double height;
  final Widget child;
  final bool showCounter;
  final String? counterText;
  final EdgeInsets? contentPadding;
  final bool locked; // 입력/터치 차단
  final bool dimOnLocked; // 잠금 시 톤다운 여부

  const EditorContainer({
    super.key,
    required this.height,
    required this.child,
    this.showCounter = false,
    this.counterText,
    this.contentPadding,
    this.locked = false,
    this.dimOnLocked = true,
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
    _scope = FocusScopeNode(canRequestFocus: !widget.locked)
      ..addListener(_onFocus);
  }

  @override
  void didUpdateWidget(covariant EditorContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    _scope.canRequestFocus = !widget.locked;
    if (oldWidget.locked != widget.locked) {
      ContextMenuController.removeAny();
      if (widget.locked && _scope.hasFocus) _scope.unfocus();
    }
  }

  void _onFocus() => setState(() => _focused = _scope.hasFocus);

  @override
  void dispose() {
    _scope.removeListener(_onFocus);
    ContextMenuController.removeAny();
    _scope.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pad =
        widget.contentPadding ?? EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 4.h);
    final showFocus = _focused && !widget.locked;
    final borderColor = showFocus ? AppColors.primary : AppColors.border;

    final bg = widget.dimOnLocked && widget.locked
        ? AppColors.surface
        : AppColors.white;
    final opacity = widget.locked ? 0.6 : 1.0;

    return SizedBox(
      height: widget.height.h,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 120),
        opacity: opacity,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: borderColor, width: 1),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: FocusScope(
              node: _scope,
              child: IgnorePointer(
                ignoring: widget.locked,
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
          ),
        ),
      ),
    );
  }
}
