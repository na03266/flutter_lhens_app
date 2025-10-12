import 'package:flutter/material.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';

class CountInline extends StatelessWidget {
  final String label;
  final int count;
  final String suffix;
  final Color? labelColor;
  final Color? countColor;
  final bool showSuffix;

  const CountInline({
    super.key,
    required this.label,
    required this.count,
    this.suffix = '건',
    this.labelColor,
    this.countColor,
    this.showSuffix = true,
  });

  @override
  Widget build(BuildContext context) {
    final baseStyle = AppTextStyles.psb14.copyWith(
      color: labelColor ?? AppColors.text,
    );

    return RichText(
      text: TextSpan(
        style: baseStyle,
        children: [
          TextSpan(text: label),
          const TextSpan(text: ' '),
          TextSpan(
            text: '$count',
            style: baseStyle.copyWith(color: countColor ?? AppColors.navy),
          ),
          if (showSuffix && suffix.isNotEmpty) TextSpan(text: suffix),
        ],
      ),
    );
  }
}
