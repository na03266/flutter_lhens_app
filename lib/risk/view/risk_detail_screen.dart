import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lhens_app/common/components/dialogs/confirm_dialog.dart';
import 'package:lhens_app/common/components/report/report_detail_scaffold_v2.dart';
import 'package:lhens_app/drawer/model/create_post_dto.dart';
import 'package:lhens_app/drawer/model/post_detail_model.dart';
import 'package:lhens_app/mock/comment/mock_comment_models.dart';
import 'package:lhens_app/risk/provider/risk_provider.dart';
import 'package:lhens_app/risk/view/risk_form_screen.dart';
import 'package:lhens_app/user/model/user_model.dart';
import 'package:lhens_app/user/provider/user_me_provier.dart';

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
    final me = ref.watch(userMeProvider);

    return ReportDetailScaffoldV2.fromModel(
      model: state,
      onUpdate:
          state.wrHit == 0 &&
              me is UserModel &&
              (me.mbLevel == 10 || state.wrName.contains(me.mbId))
          ? () {
              context.goNamed(
                RiskFormScreen.routeNameUpdate,
                pathParameters: {'rid': widget.wrId},
              );
            }
          : null,
      onDelete:
          me is UserModel &&
              (me.mbLevel == 10 || state.wrName.contains(me.mbId))
          ? () {
              try {
                ref.read(riskProvider.notifier).deletePost(wrId: widget.wrId);
              } on DioException catch (e) {
                final data = e.response?.data;
                String? serverMsg;
                if (data is Map<String, dynamic>) {
                  final m = data['message'];
                  if (m is String) {
                    serverMsg = m;
                  } else if (m is List && m.isNotEmpty) {
                    serverMsg = m.first.toString();
                  }
                  _showMsg(serverMsg ?? '삭제 중 오류가 발생했습니다.');
                }
              }
              _showMsg('정상적으로 삭제되었습니다.');
            }
          : null,
      postComment: (wrId, dto) {
        ref.read(riskProvider.notifier).postComment(wrId: wrId, dto: dto);
      },
      postReply: (wrId, coId, dto) {
        ref
            .read(riskProvider.notifier)
            .postReComment(wrId: wrId, dto: dto, coId: coId);
      },
      onProgressUpdate: (wrId, wr2) {
        ref
            .read(riskProvider.notifier)
            .patchPost(
              wrId: wrId,
              dto: CreatePostDto(wrContent: state.wrContent, wr2: wr2),
            );
      },
    );
  }

  void _showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(seconds: 1)),
    );
  }
}
