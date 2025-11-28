import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lhens_app/common/components/user_avatar.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';
import 'package:lhens_app/common/utils/data_utils.dart';
import 'package:lhens_app/drawer/model/post_comment_model.dart';
import 'package:lhens_app/mock/comment/mock_comment_models.dart';
import 'reply_tile.dart';

class CommentTileV2<T> extends StatelessWidget {
  final PostCommentModel comment;
  final bool isReply;
  final void Function(int id, String name)? onTapReply;
  final bool Function(PostCommentModel c)? canDeleteOf;
  final bool Function(PostCommentModel c)? deletingOf;
  final void Function(PostCommentModel c)? onRequestDelete;

  const CommentTileV2({
    super.key,
    required this.comment,
    required this.isReply,
    this.onTapReply,
    this.canDeleteOf,
    this.deletingOf,
    this.onRequestDelete,
  });

  @override
  Widget build(BuildContext context) {
    final canDeleteMe = canDeleteOf?.call(comment) ?? false;
    final deletingMe = deletingOf?.call(comment) ?? false;

    Widget? deleteBtn;
    if (canDeleteMe) {
      deleteBtn = GestureDetector(
        onTap: deletingMe ? null : () => onRequestDelete?.call(comment),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: deletingMe
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    strokeCap: StrokeCap.round,
                    valueColor: AlwaysStoppedAnimation(AppColors.subtle),
                  ),
                )
              : Text(
                  '삭제',
                  style: AppTextStyles.pr14.copyWith(color: AppColors.textTer),
                ),
        ),
      );
    }

    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.subtle, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 상위 댓글 헤더
          Padding(
            padding: EdgeInsets.only(
              top: 16.h,
              right: 6.w,
              bottom: 16.h,
              left: isReply ? 32.w : 0,
            ),
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
                              comment.wrName,
                              style: AppTextStyles.psb14.copyWith(
                                color: AppColors.textSec,
                              ),
                            ),
                          ),
                          if (deleteBtn != null) deleteBtn,
                        ],
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        comment.wrContent,
                        style: AppTextStyles.pr15.copyWith(
                          color: AppColors.text,
                          height: 1.35,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          Text(
                            DataUtils.datetimeParse(comment.wrDatetime),
                            style: AppTextStyles.pl14.copyWith(
                              color: AppColors.textTer,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          GestureDetector(
                            onTap: () => onTapReply?.call(
                              comment.wrId,
                              comment.wrName,
                            ),
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
          ),
        ],
      ),
    );
  }
}
