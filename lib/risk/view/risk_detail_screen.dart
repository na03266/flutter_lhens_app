import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:lhens_app/common/components/dialogs/confirm_dialog.dart';
import 'package:lhens_app/common/components/label_value_line.dart';
import 'package:lhens_app/common/components/report/report_detail_scaffold.dart';
import 'package:lhens_app/common/components/report/report_detail_header.dart';
import 'package:lhens_app/common/components/comments/comments_section.dart';
import 'package:lhens_app/common/components/comments/comment_tile.dart';
import 'package:lhens_app/mock/comment/mock_comment_data.dart';
import 'package:lhens_app/mock/comment/mock_comment_models.dart';

class RiskDetailScreen extends ConsumerStatefulWidget {
  static String get routeName => '위험신고 상세';

  const RiskDetailScreen({super.key});

  @override
  ConsumerState<RiskDetailScreen> createState() => _RiskDetailScreenState();
}

class _RiskDetailScreenState extends ConsumerState<RiskDetailScreen> {
  final deletingIds = <String>{};

  void _handleDelete(CommentModel c) async {
    final ok = await ConfirmDialog.show(
      context,
      title: '댓글 삭제',
      message: '이 댓글을 삭제하시겠습니까?',
      confirmText: '삭제',
      destructive: true,
    );
    if (ok != true) return;

    setState(() => deletingIds.add(c.id));
    await Future.delayed(const Duration(seconds: 1)); // mock
    setState(() => deletingIds.remove(c.id));

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('삭제되었습니다.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    const type = '신고유형명';
    const title = '신고 제목이 표시되는 영역입니다.';

    // 로그인 사용자 (임시)
    const currentUser = '조예빈(1001599)';

    return ReportDetailScaffold(
      config: ReportDetailConfig(
        typeName: type,
        title: title,
        headerBuilder: (onMore) =>
            ReportDetailHeader(typeName: type, title: title, onMoreTap: onMore),
        metaRows: const [
          LabelValueLine.single(label1: '작성자', value1: '조예빈(1001599)'),
          LabelValueLine.single(label1: '등록일', value1: '2025. 08. 28'),
          LabelValueLine.single(label1: '진행상황', value1: '접수'),
          LabelValueLine.single(label1: '공개여부', value1: '공개'),
        ],
        body: const Text('내용이 표시되는\n영역입니다.'),
        attachments: const ['첨부파일명.pdf'],
        editRouteName: '위험신고 수정',
        myEditRouteName: '내 위험신고 수정',
      ),
      commentsBuilder: (onReplyTap) => CommentsSection(
        comments: mockComments,
        onTapReply: onReplyTap,
        tileBuilder: (c) => CommentTile(
          comment: c,
          canDeleteOf: (m) => m.user == currentUser,
          deletingOf: (m) => deletingIds.contains(m.id),
          onRequestDelete: _handleDelete,
          onTapReply: onReplyTap,
        ),
      ),
    );
  }
}
