import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lhens_app/common/components/count_inline.dart';
import 'package:lhens_app/common/components/inputs/inline_action_field.dart';
import 'package:lhens_app/mock/comment/mock_comment_data.dart'; // ✅ mock 데이터 합계 불러오기
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
    final totalCount = mockTotalCommentCount; // 이후 서버 값으로 교체

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: hpad + 2.w),
          child: CountInline(label: '댓글', count: totalCount, showSuffix: false),
        ),
        SizedBox(height: 16.h),

        // 입력창
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

        // 댓글 리스트
        Padding(
          padding: EdgeInsets.symmetric(horizontal: hpad),
          child: Column(
            children: [
              for (final c in comments) ...[
                CommentTile(comment: c),
                SizedBox(height: 2.h),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
