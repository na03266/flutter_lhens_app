import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_shadows.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';

class HomeNavCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback onTap;

  const HomeNavCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final double cardHeight = 80.h;
    final double iconSize = 35.sp;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: cardHeight,
        padding: EdgeInsets.fromLTRB(16.w, 12.w, 8.w, 8.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: AppShadows.card,
        ),
        child: Stack(
          children: [
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.jb14.copyWith(color: AppColors.text,fontSize: 17.sp
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: SizedBox(
                width: iconSize,
                height: iconSize,
                child: Image.asset(imagePath, fit: BoxFit.contain),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
