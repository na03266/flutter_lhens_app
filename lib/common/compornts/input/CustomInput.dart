import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../const/appColorPicker.dart';

class CustomInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obscureText;

  const CustomInput({
    super.key,
    required this.controller,
    required this.label,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(fontSize: 17.r),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: 17.r, color: AppColors.labelColor),

        // 평상시 테두리 색상
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: AppColors.loginDefaultColor, // 기본 테두리 색상
            width: 1,
          ),
        ),

        // 포커스 상태 테두리 색상
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: AppColors.loginActiveColor, // 포커스시 테두리 색상
            width: 2,
          ),
        ),

        // 에러 상태 테두리 색상
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: AppColors.loginErrorColor, // 에러 테두리
            width: 1.5,
          ),
        ),

        // 에러 + 포커스 상태 테두리 색상
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: AppColors.loginErrorColor,
            width: 2,
          ),
        ),

        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 12,
        ),
      ),
    );
  }
}
