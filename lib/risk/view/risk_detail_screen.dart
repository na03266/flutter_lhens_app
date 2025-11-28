import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lhens_app/common/components/dialogs/confirm_dialog.dart';
import 'package:lhens_app/common/components/report/report_detail_scaffold_v2.dart';
import 'package:lhens_app/drawer/model/post_detail_model.dart';
import 'package:lhens_app/mock/comment/mock_comment_models.dart';
import 'package:lhens_app/risk/provider/risk_provider.dart';
import 'package:lhens_app/risk/view/risk_form_screen.dart';

class RiskDetailScreen extends ConsumerStatefulWidget {
  static String get routeName => '위험신고 상세';
  final String wrId;

  const RiskDetailScreen({super.key, required this.wrId});

  @override
  ConsumerState<RiskDetailScreen> createState() => _RiskDetailScreenState();
}

class _RiskDetailScreenState extends ConsumerState<RiskDetailScreen> {
  final deletingIds = <String>{};

  @override
  void initState() {
    super.initState();
    ref.read(riskProvider.notifier).getDetail(wrId: widget.wrId);
  }

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
    final state = ref.watch(riskDetailProvider(widget.wrId));

    if (state == null || state is! PostDetailModel) {
      return Center(child: CircularProgressIndicator());
    }
    return ReportDetailScaffoldV2.fromModel(
      model: state,
      onUpdate: () {
        context.goNamed(
          RiskFormScreen.routeNameUpdate,
          pathParameters: {'rid': widget.wrId},
        );
      },
      postComment: (wrId, dto) {
        ref.read(riskProvider.notifier).postComment(wrId: wrId, dto: dto);
      },
      postReply: (wrId, coId, dto) {
        ref
            .read(riskProvider.notifier)
            .postReComment(wrId: wrId, dto: dto, coId: coId);
      },
    );
  }
}
