import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../const/appBorderRadius.dart';
import '../../const/appColorPicker.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? color;

  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isColored = color != null;

    return SizedBox(
      width: double.infinity, // 부모의 가로 전체 너비 차지
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? AppColors.primaryColor,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: AppBorderRadius.radius10,
          ),
          side: BorderSide(
            color: isColored ? AppColors.darkBlueColor : Colors.transparent,
            width: 1,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 20.r,
            fontWeight: FontWeight.bold,
            color: isColored ? AppColors.darkBlueColor : Colors.white,
          ),
        ),
      ),
    );
  }
}
