import 'package:flutter/material.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';
import 'package:lhens_app/common/theme/app_colors.dart';

class LinkText extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final TextAlign textAlign;

  const LinkText({
    super.key,
    required this.text,
    this.onTap,
    this.textAlign = TextAlign.right,
  });

  @override
  Widget build(BuildContext context) {
    final alignment = switch (textAlign) {
      TextAlign.center => Alignment.center,
      TextAlign.right => Alignment.centerRight,
      _ => Alignment.centerLeft,
    };

    return Align(
      alignment: alignment,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onTap,
        child: Text(
          text,
          textAlign: textAlign,
          style: AppTextStyles.pr15.copyWith(color: AppColors.textSec),
        ),
      ),
    );
  }
}
