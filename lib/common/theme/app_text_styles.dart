import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';

class AppTextStyles {
  // ---------------- Pretendard ----------------
  static final TextStyle pb18 = TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 18.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.text,
    letterSpacing: -0.68,
    height: 1.2,
  );

  static final TextStyle pb16 = pb18.copyWith(fontSize: 16.sp);
  static final TextStyle pb15 = pb18.copyWith(fontSize: 15.sp);
  static final TextStyle pb14 = pb18.copyWith(fontSize: 14.sp);
  static final TextStyle pb13 = pb18.copyWith(fontSize: 13.sp);
  static final TextStyle pb12 = pb18.copyWith(fontSize: 12.sp);

  // SemiBold
  static final TextStyle psb18 = pb18.copyWith(fontWeight: FontWeight.w600);
  static final TextStyle psb14 = psb18.copyWith(fontSize: 14.sp);
  static final TextStyle psb13 = psb18.copyWith(fontSize: 13.sp);
  static final TextStyle psb12 = psb18.copyWith(fontSize: 12.sp);

  // Medium
  static final TextStyle pm18 = pb18.copyWith(fontWeight: FontWeight.w500);
  static final TextStyle pm16 = pm18.copyWith(fontSize: 16.sp);
  static final TextStyle pm15 = pm18.copyWith(fontSize: 15.sp);
  static final TextStyle pm14 = pm18.copyWith(fontSize: 14.sp);
  static final TextStyle pm13 = pm18.copyWith(fontSize: 13.sp);
  static final TextStyle pm12 = pm18.copyWith(fontSize: 12.sp);

  // Regular
  static final TextStyle pr18 = pb18.copyWith(fontWeight: FontWeight.w400);
  static final TextStyle pr16 = pr18.copyWith(fontSize: 16.sp);
  static final TextStyle pr15 = pr18.copyWith(fontSize: 15.sp);
  static final TextStyle pr14 = pr18.copyWith(fontSize: 14.sp);
  static final TextStyle pr12 = pr18.copyWith(fontSize: 12.sp);

  // ---------------- The Jamsil ----------------
  // Bold
  static final TextStyle jb18 = TextStyle(
    fontFamily: 'TheJamsil',
    fontSize: 18.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.text,
    letterSpacing: -0.45,
    height: 1,
  );

  static final TextStyle jb14 = jb18.copyWith(fontSize: 14.sp);

  // Medium
  static final TextStyle jm18 = jb18.copyWith(fontWeight: FontWeight.w500);
  static final TextStyle jm16 = jm18.copyWith(fontSize: 16.sp);

  // Regular
  static final TextStyle jr18 = jb18.copyWith(fontWeight: FontWeight.w400);
  static final TextStyle jr16 = jr18.copyWith(fontSize: 16.sp);
}
