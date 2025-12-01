import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';

class HomeEventCard extends StatelessWidget {
  final String title;
  final String periodText;
  final String imagePath;
  final VoidCallback? onTap;

  const HomeEventCard({
    super.key,
    required this.title,
    required this.periodText,
    required this.imagePath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 비율 3:2
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: AspectRatio(
              aspectRatio: 3 / 2,
              child: (imagePath.isEmpty)
                  // 1. 이미지 경로가 아예 없을 때
                  ? Container(
                      color: Colors.grey.shade200,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.image_not_supported,
                        size: 32.r,
                        color: Colors.grey,
                      ),
                    )
                  // 2. 네트워크 이미지 로드 시도
                  : Image.network(
                      imagePath,
                      fit: BoxFit.cover,
                      // 2-1. 로딩 중 처리
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: Colors.grey.shade100,
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                      (loadingProgress.expectedTotalBytes ?? 1)
                                : null,
                          ),
                        );
                      },
                      // 2-2. 에러(404, 네트워크 실패 등) 처리
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey.shade200,
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.broken_image,
                            size: 32.r,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
            ),
          ),
          SizedBox(height: 16.h),

          // 제목
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.psb18.copyWith(
              fontSize: 16.sp,
              color: AppColors.text,
            ),
          ),
          SizedBox(height: 6.h),

          // 기간
          Row(
            children: [
              Text(
                '기간',
                style: AppTextStyles.psb12.copyWith(color: AppColors.textTer),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Text(
                  periodText,
                  style: AppTextStyles.pr12.copyWith(
                    color: AppColors.textTer,
                    letterSpacing: -0.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
