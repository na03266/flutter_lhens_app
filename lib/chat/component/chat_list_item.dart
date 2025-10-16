import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';

class ChatListItem extends StatelessWidget {
  final String title; // 그룹명
  final int participants; // 참여자 수
  final int unreadCount; // 안읽은 메시지 수
  final VoidCallback? onTap;

  const ChatListItem({
    super.key,
    required this.title,
    required this.participants,
    this.unreadCount = 0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: 48.h),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: ShapeDecoration(
            color: AppColors.white,
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 1, color: AppColors.border),
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 그룹명 + 배지
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.pm16.copyWith(
                              color: AppColors.text,
                            ),
                          ),
                        ),
                        if (unreadCount > 0) ...[
                          SizedBox(width: 6.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 5.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(50.r),
                            ),
                            child: SizedBox(
                              width: 8.w,
                              child: Text(
                                '$unreadCount',
                                textAlign: TextAlign.center,
                                style: AppTextStyles.pb12.copyWith(
                                  color: AppColors.white,
                                  height: 0.83,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 6.h),

                    // 참여자
                    Row(
                      children: [
                        SizedBox(
                          width: 52.w,
                          child: Text(
                            '참여자',
                            style: AppTextStyles.pb14.copyWith(
                              color: AppColors.textTer,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '$participants명',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.pr14.copyWith(
                              color: AppColors.textTer,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
