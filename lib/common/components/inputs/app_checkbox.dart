import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lhens_app/gen/assets.gen.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';

enum AppCheckboxStyle { primary, secondary }

class AppCheckbox extends StatelessWidget {
  final String label;
  final Widget? labelWidget;
  final bool value;
  final ValueChanged<bool> onChanged;
  final AppCheckboxStyle style;
  final double? size;
  final double? spacing;
  final bool compact;

  const AppCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.label = '',
    this.labelWidget,
    this.style = AppCheckboxStyle.primary,
    this.size,
    this.spacing,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final iconSize = (size ?? 24.0).w;
    final gap = (spacing ?? 4.0).w;
    final hasLabel = labelWidget != null || label.isNotEmpty;

    final textStyle =
        (style == AppCheckboxStyle.secondary
                ? AppTextStyles.pm14
                : AppTextStyles.pm16)
            .copyWith(color: AppColors.textSec);

    final icon = AnimatedSwitcher(
      duration: const Duration(milliseconds: 150),
      transitionBuilder: (c, a) => FadeTransition(opacity: a, child: c),
      child: _buildIcon(iconSize),
    );

    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon,
        if (hasLabel) SizedBox(width: gap),
        if (labelWidget != null)
          labelWidget!
        else if (label.isNotEmpty)
          Text(label, style: textStyle),
      ],
    );

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => onChanged(!value),
      child: compact
          ? SizedBox(width: iconSize, height: iconSize, child: content)
          : ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
              child: content,
            ),
    );
  }

  Widget _buildIcon(double size) {
    switch (style) {
      case AppCheckboxStyle.secondary:
        return (value ? Assets.icons.checkedSecondary : Assets.icons.unchecked)
            .svg(key: ValueKey(value), width: size, height: size);
      case AppCheckboxStyle.primary:
        return (value ? Assets.icons.checked : Assets.icons.unchecked).svg(
          key: ValueKey(value),
          width: size,
          height: size,
        );
    }
  }
}
