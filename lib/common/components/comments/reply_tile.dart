import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lhens_app/common/components/user_avatar.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';
import 'package:lhens_app/mock/comment/mock_comment_models.dart';

class ReplyTile extends StatelessWidget {
  final CommentModel comment;
  final VoidCallback? onTapReply;
  final bool canDelete;
  final bool deleting;
  final VoidCallback? onRequestDelete;

  const ReplyTile({
    super.key,
    required this.comment,
    this.onTapReply,
    this.canDelete = false,
    this.deleting = false,
    this.onRequestDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 4.h, right: 6.w, bottom: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const UserAvatar(size: 36, iconSize: 20),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        comment.user,
                        style: AppTextStyles.psb14.copyWith(
                          color: AppColors.textSec,
                        ),
                      ),
                    ),
                    if (canDelete)
                      GestureDetector(
                        onTap: deleting ? null : onRequestDelete,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 4.w,
                            vertical: 2.h,
                          ),
                          child: deleting
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    strokeCap: StrokeCap.round,
                                    valueColor: AlwaysStoppedAnimation(
                                      AppColors.subtle,
                                    ),
                                  ),
                                )
                              : Text(
                                  '삭제',
                                  style: AppTextStyles.pr14.copyWith(
                                    color: AppColors.textTer,
                                  ),
                                ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 6.h),
                Text(
                  comment.text,
                  style: AppTextStyles.pr15.copyWith(color: AppColors.text),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Text(
                      comment.time,
                      style: AppTextStyles.pl14.copyWith(
                        color: AppColors.textTer,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    GestureDetector(
                      onTap: onTapReply,
                      behavior: HitTestBehavior.opaque,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 4.w,
                          vertical: 2.h,
                        ),
                        child: Text(
                          '답글쓰기',
                          style: AppTextStyles.pr14.copyWith(
                            color: AppColors.textTer,
                          ),
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
    );
  }
}
