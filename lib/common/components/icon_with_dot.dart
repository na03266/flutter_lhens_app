import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';

enum DotType { primary, yellow }

extension DotTypeColor on DotType {
  Color get color {
    switch (this) {
      case DotType.primary:
        return AppColors.primary;
      case DotType.yellow:
        return const Color(0xFFFFEB00);
    }
  }
}

class IconWithDot extends StatelessWidget {
  final Widget icon;
  final bool showDot;
  final DotType dotType;
  final double dotSize;

  const IconWithDot({
    super.key,
    required this.icon,
    this.showDot = false,
    this.dotType = DotType.primary,
    this.dotSize = 5,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32.w,
      height: 32.w,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Center(child: icon),
          if (showDot)
            Positioned(
              top: 4,
              right: 4,
              child: Container(
                width: dotSize.w,
                height: dotSize.w,
                decoration: BoxDecoration(
                  color: dotType.color,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
