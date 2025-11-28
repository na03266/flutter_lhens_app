import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lhens_app/common/components/feedback/press_scale.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/drawer/model/post_model.dart';
import 'package:lhens_app/gen/assets.gen.dart';

class DocListItem extends StatelessWidget {
  final String? category; // 없으면 숨김
  final String title;
  final VoidCallback? onPreview;
  final VoidCallback? onDownload;

  const DocListItem({
    super.key,
    this.category,
    required this.title,
    this.onPreview,
    this.onDownload,
  });

  factory DocListItem.fromModel({required PostModel model}) {
    return DocListItem(category: model.wr1, title: model.wrSubject);
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 48.h),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            // 텍스트
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (category != null) ...[
                    Text(
                      category!,
                      style: AppTextStyles.pr13.copyWith(
                        color: AppColors.textTer,
                      ),
                    ),
                    SizedBox(height: 4.h),
                  ],
                  Text(
                    title,
                    style: AppTextStyles.pm16.copyWith(color: AppColors.text),
                  ),
                ],
              ),
            ),

            // 아이콘 버튼
            if (onPreview != null)
              Row(
                children: [
                  _icon(
                    onTap: onPreview,
                    icon: Assets.icons.document.svg(width: 20.w, height: 20.w),
                    bgColor: AppColors.surface,
                  ),
                  // SizedBox(width: 8.w),
                  // _icon(
                  //   onTap: onDownload,
                  //   icon: Assets.icons.download.svg(width: 20.w, height: 20.w),
                  //   bgColor: AppColors.primarySoft,
                  // ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _icon({
    required VoidCallback? onTap,
    required Widget icon,
    required Color bgColor,
  }) {
    return PressScale(
      onTap: onTap,
      child: Container(
        width: 44.w,
        height: 44.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: icon,
      ),
    );
  }
}
