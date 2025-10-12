import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';

class CommunicationListItem extends StatelessWidget {
  final String title; // 그룹명
  final int participants; // 참여자 수
  final int unreadCount; // 안읽은 메시지 수
  final VoidCallback? onTap;

  const CommunicationListItem({
    super.key,
    required this.title,
    required this.participants,
    this.unreadCount = 0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.borderStrong),
          ),
        ),
        padding: EdgeInsets.only(top: 4.h, bottom: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상단: 그룹명 + 안읽은 배지
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
                if (unreadCount > 0)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 4.h),
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
            ),
            SizedBox(height: 8.h),

            // 참여자
            Row(
              children: [
                SizedBox(
                  width: 52.w,
                  child: Text(
                    '참여자',
                    style: AppTextStyles.pb14.copyWith(color: AppColors.textTer),
                  ),
                ),
                Expanded(
                  child: Text(
                    '${participants}명',
                    style: AppTextStyles.pr14.copyWith(color: AppColors.textTer),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
