import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lhens_app/gen/assets.gen.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class AppCheckbox extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final double? size;
  final double? spacing;
  final TextStyle? labelStyle;

  const AppCheckbox({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.size,
    this.spacing,
    this.labelStyle,
  });

  @override
  Widget build(BuildContext context) {
    final double effectiveSize = (size ?? 24.0).w;
    final double effectiveSpacing = (spacing ?? 6.0).w;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => onChanged(!value),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 150),
              transitionBuilder: _fade,
              child: (value ? Assets.icons.checked : Assets.icons.unchecked)
                  .svg(
                    key: ValueKey<bool>(value),
                    width: effectiveSize,
                    height: effectiveSize,
                  ),
            ),
            SizedBox(width: effectiveSpacing),
            Text(
              label,
              style: (labelStyle ?? AppTextStyles.pm16).copyWith(
                color: AppColors.textSec,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _fade(Widget child, Animation<double> a) =>
      FadeTransition(opacity: a, child: child);
}
