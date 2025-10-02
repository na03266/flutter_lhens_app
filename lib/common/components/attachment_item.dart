import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';
import 'package:lhens_app/gen/assets.gen.dart';

class AttachmentItem extends StatelessWidget {
  final String filename;
  final VoidCallback onRemove;

  const AttachmentItem({
    super.key,
    required this.filename,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 14.h, bottom: 14.h, left: 4.w),
          child: Row(
            children: [
              // 아이콘 박스
              Container(
                width: 52.w,
                height: 52.w,
                decoration: BoxDecoration(
                  color: AppColors.subtle,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Center(
                  child: Assets.icons.file.svg(width: 22.w, height: 22.w),
                ),
              ),
              SizedBox(width: 16.w),

              // 파일 이름
              Expanded(
                child: Text(
                  filename,
                  style: AppTextStyles.pr14.copyWith(color: AppColors.textSec),
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // 삭제 버튼 (터치 영역 확장 + 커스텀 아이콘)
              GestureDetector(
                onTap: onRemove,
                behavior: HitTestBehavior.translucent,
                child: SizedBox(
                  width: 44.w,
                  height: 44.w,
                  child: Center(
                    child: Assets.icons.closeSecondary.svg(
                      width: 24.w,
                      height: 24.w,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        Divider(height: 1, thickness: 1, color: AppColors.border),
      ],
    );
  }
}
