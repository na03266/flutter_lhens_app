// lib/risk/component/comments_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lhens_app/common/components/count_inline.dart';
import 'package:lhens_app/common/components/inputs/inline_action_field.dart';
import 'package:lhens_app/mock/comment/mock_comment_models.dart';
import 'package:lhens_app/risk/component/comment_tile.dart';

class CommentsSection extends StatelessWidget {
  final List<CommentModel> comments;
  final TextEditingController controller;
  final VoidCallback onSend;

  const CommentsSection({
    super.key,
    required this.comments,
    required this.controller,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    final hpad = 18.w;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 카운트
        Padding(
          padding: EdgeInsets.symmetric(horizontal: hpad + 2.w),
          child: CountInline(label: '댓글', count: comments.length),
        ),
        SizedBox(height: 16.h),
        // 입력
        Padding(
          padding: EdgeInsets.symmetric(horizontal: hpad),
          child: InlineActionField(
            variant: InlineActionVariant.comment,
            controller: controller,
            hint: '댓글을 입력해주세요.',
            onAction: onSend,
          ),
        ),
        SizedBox(height: 4.h),
        // 리스트
        Padding(
          padding: EdgeInsets.symmetric(horizontal: hpad),
          child: Column(
            children: [
              for (final c in comments) ...[
                CommentTile(comment: c),
                SizedBox(height: 8.h),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
