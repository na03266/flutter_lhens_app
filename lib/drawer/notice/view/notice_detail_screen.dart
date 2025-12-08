import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lhens_app/common/components/dialogs/confirm_dialog.dart';
import 'package:lhens_app/common/components/report/report_detail_scaffold_v2.dart';
import 'package:lhens_app/drawer/model/post_detail_model.dart';
import 'package:lhens_app/drawer/notice/provider/notice_provider.dart';
import 'package:lhens_app/drawer/notice/view/notice_form_screen.dart';
import 'package:lhens_app/user/model/user_model.dart';
import 'package:lhens_app/user/provider/user_me_provier.dart';

class NoticeDetailScreen extends ConsumerStatefulWidget {
  static String get routeName => '공지사항 상세';
  final String wrId;

  const NoticeDetailScreen({super.key, required this.wrId});

  @override
  ConsumerState<NoticeDetailScreen> createState() => _NoticeDetailScreenState();
}

class _NoticeDetailScreenState extends ConsumerState<NoticeDetailScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(noticeProvider.notifier).getDetail(wrId: widget.wrId);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(noticeDetailProvider(widget.wrId));

    if (state == null || state is! PostDetailModel) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final me = ref.watch(userMeProvider);

    return ReportDetailScaffoldV2.fromModel(
      model: state,
      onUpdate:
      me is UserModel && (me.mbLevel > 10 || state.wrName.contains(me.mbId))
          ? () {
        context.goNamed(
          NoticeFormScreen.routeNameUpdate,
          pathParameters: {'rid': widget.wrId},
        );
      }
          : null,
      onDelete:
      me is UserModel && (me.mbLevel > 10 || state.wrName.contains(me.mbId))
          ? () {
        try {
          ref.read(noticeProvider.notifier).deletePost(wrId: widget.wrId);
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
        ref.read(noticeProvider.notifier).postComment(wrId: wrId, dto: dto);
      },

      postReply: (wrId, coId, dto) {
        ref
            .read(noticeProvider.notifier)
            .postReComment(wrId: wrId, dto: dto, coId: coId);
      },
      canCommentDeleteOf: (item) {
        if (me is UserModel) {
          return item.wrName.contains(me.mbId);
        }
        return false;
      },
      onCommentDelete: (item) async {
        final ok = await ConfirmDialog.show(
          context,
          title: '삭제',
          message: '삭제시 복구할수 없습니다.\n삭제 하시겠습니까?',
          destructive: true,
        );
        if (!mounted) return;
        if (ok == true) {
          try {
            ref
                .read(noticeProvider.notifier)
                .deletePost(wrId: item.wrId.toString());
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
          ref.read(noticeProvider.notifier).getDetail(wrId: widget.wrId);
        }
      },
      onCommentUpdate: (id, item) async {
        await ref.read(noticeProvider.notifier).patchPost(wrId: id, dto: item);
      },
    );
  }

  void _showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(seconds: 1)),
    );
  }
}
