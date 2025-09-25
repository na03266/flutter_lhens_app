import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppShadows {
  const AppShadows._();

  static List<BoxShadow> get homeButton => [
    BoxShadow(
      color: AppColors.text.withValues(alpha: 0.25),
      blurRadius: 4,
      offset: const Offset(2, 4),
    ),
  ];

  static List<BoxShadow> get card => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.25),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ];
}