import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lhens_app/common/components/comments/comment_tile.dart';
import 'package:lhens_app/common/components/count_inline.dart';
import 'package:lhens_app/drawer/model/post_comment_model.dart';
import 'package:lhens_app/mock/comment/mock_comment_data.dart';
import 'package:lhens_app/mock/comment/mock_comment_models.dart';

import 'comment_tile_v2.dart';

class CommentsSectionV2 extends StatelessWidget {
  final List<PostCommentModel> comments;
  final void Function(int id, String name)? onTapReply;
  final bool Function(PostCommentModel c)? canDeleteOf;
  final void Function(PostCommentModel c)? onDelete;
  final void Function(PostCommentModel c)? onUpdate;

  const CommentsSectionV2({
    super.key,
    required this.comments,
    this.onTapReply,
    this.canDeleteOf,
    this.onDelete,
    this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final hpad = 18.w;
    final totalCount = comments.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: hpad + 2.w),
          child: CountInline(label: '댓글', count: totalCount, showSuffix: false),
        ),
        SizedBox(height: 12.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: hpad),
          child: Column(
            children: [
              for (final c in comments) ...[
                CommentTileV2(
                  comment: c,
                  onTapReply: onTapReply,
                  isReply: c.wrCommentReply.isNotEmpty,
                  canDeleteOf: canDeleteOf,
                  onDelete: onDelete,
                  onUpdate: onUpdate,
                ),
                SizedBox(height: 2.h),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
