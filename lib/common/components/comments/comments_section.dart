import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lhens_app/common/components/comments/comment_tile.dart';
import 'package:lhens_app/common/components/count_inline.dart';
import 'package:lhens_app/mock/comment/mock_comment_data.dart';
import 'package:lhens_app/mock/comment/mock_comment_models.dart';

class CommentsSection extends StatelessWidget {
  final List<CommentModel> comments;
  final void Function(String id, String name) onTapReply;
  final Widget Function(CommentModel c)? tileBuilder;

  const CommentsSection({
    super.key,
    required this.comments,
    required this.onTapReply,
    this.tileBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final hpad = 18.w;
    final totalCount = mockTotalCommentCount;

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
                tileBuilder?.call(c) ??
                    CommentTile(
                      comment: c,
                      onTapReply: onTapReply,
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
