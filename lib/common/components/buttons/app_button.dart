import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import 'package:lhens_app/common/components/feedback/press_scale.dart';

enum AppButtonType { primary, secondary, outlined, plain }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final AppButtonType type;
  final double? height;
  final double? width;

  const AppButton({
    super.key,
    required this.text,
    this.onTap,
    this.type = AppButtonType.primary,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;

    Color bg = AppColors.white;
    Color textColor = AppColors.text;
    Color borderColor = Colors.transparent;

    switch (type) {
      case AppButtonType.primary:
        bg = enabled ? AppColors.primary : AppColors.border;
        textColor = AppColors.white;
        break;
      case AppButtonType.secondary:
        bg = enabled ? AppColors.secondary : AppColors.border;
        textColor = AppColors.white;
        break;
      case AppButtonType.outlined:
        bg = AppColors.white;
        textColor = enabled ? AppColors.text : AppColors.placeholder;
        borderColor = enabled ? AppColors.secondary : AppColors.border;
        break;
      case AppButtonType.plain:
        textColor = enabled ? AppColors.text : AppColors.placeholder;
        break;
    }

    return PressScale(
      onTap: onTap,
      child: Container(
        width: width ?? double.infinity,
        height: height ?? 56.h,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12.r),
          border: borderColor == Colors.transparent
              ? null
              : Border.all(color: borderColor),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: AppTextStyles.pb16.copyWith(color: textColor),
        ),
      ),
    );
  }
}
