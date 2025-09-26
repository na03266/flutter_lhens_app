import 'package:flutter/material.dart';
import 'package:lhens_app/common/components/feedback/press_highlight.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class ExitActionButton extends StatelessWidget {
  final String label;
  final Widget icon;
  final VoidCallback onTap;

  const ExitActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: PressHighlight(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: AppTextStyles.psb14.copyWith(color: AppColors.text),
              ),
              const SizedBox(width: 6),
              icon,
            ],
          ),
        ),
      ),
    );
  }
}
