import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lhens_app/chat/dto/create_chat_room_dto.dart';
import 'package:lhens_app/common/components/dialogs/confirm_dialog.dart';
import 'package:lhens_app/common/components/report/report_detail_scaffold_v2.dart';
import 'package:lhens_app/drawer/complaint/provider/complaint_provider.dart';
import 'package:lhens_app/drawer/complaint/view/complaint_form_screen.dart';
import 'package:lhens_app/drawer/model/create_post_dto.dart';
import 'package:lhens_app/drawer/model/post_detail_model.dart';
import 'package:lhens_app/drawer/model/post_model.dart';
import 'package:lhens_app/user/model/user_model.dart';
import 'package:lhens_app/user/model/user_pick_result.dart';
import 'package:lhens_app/user/model/user_picker_args.dart';
import 'package:lhens_app/user/provider/user_me_provier.dart';

class ComplaintDetailScreen extends ConsumerStatefulWidget {
  static String get routeName => '민원제안 상세';
  final String wrId;

  const ComplaintDetailScreen({super.key, required this.wrId});

  @override
  ConsumerState<ComplaintDetailScreen> createState() =>
      _ComplaintDetailScreenState();
}

class _ComplaintDetailScreenState extends ConsumerState<ComplaintDetailScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(complaintProvider.notifier).getDetail(wrId: widget.wrId);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(complaintDetailProvider(widget.wrId));

    if (state == null || state is! PostDetailModel) {
      if (state is PostModel) {
        ref.read(complaintProvider.notifier).getDetail(wrId: widget.wrId);
      }
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
                ComplaintFormScreen.routeNameUpdate,
                pathParameters: {'rid': widget.wrId},
              );
            }
          : null,
      onDelete:
          me is UserModel &&
              (me.mbLevel == 10 || state.wrName.contains(me.mbId))
          ? () {
              try {
                ref
                    .read(complaintProvider.notifier)
                    .deletePost(wrId: widget.wrId);
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
      onPass: me is UserModel && me.mbLevel >= 4
          ? () async {
              final res = await GoRouter.of(context).pushNamed<UserPickResult>(
                '커뮤니케이션-사용자선택',
                extra: UserPickerArgs(UserPickerMode.chatCreate),
              );

              if (!context.mounted || res == null) return;

              try {
                ref
                    .read(complaintProvider.notifier)
                    .passOnPost(
                      wrId: widget.wrId,
                      dto: CreateChatRoomDto(
                        teamNos: res.departments,
                        memberNos: res.members,
                      ),
                    );
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
                  _showMsg(serverMsg ?? '이관중 오류가 발생했습니다.');
                }
              }
              _showMsg('정상적으로 이관 처리되었습니다.');
            }
          : null,
      postComment: (wrId, dto) {
        ref.read(complaintProvider.notifier).postComment(wrId: wrId, dto: dto);
      },
      postReply: (wrId, coId, dto) {
        ref
            .read(complaintProvider.notifier)
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
            await ref
                .read(complaintProvider.notifier)
                .deleteReply(wrId: item.wrId.toString());
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
          await ref
              .read(complaintProvider.notifier)
              .getDetail(wrId: widget.wrId);
        }
      },
      onCommentUpdate: (id, item) async {
        await ref
            .read(complaintProvider.notifier)
            .patchPost(wrId: id, dto: item);
      },
      onProgressUpdate: (wrId, wr2) {
        if (me is UserModel && me.mbLevel >= 4) {
          ref
              .read(complaintProvider.notifier)
              .patchPost(
                wrId: wrId,
                dto: CreatePostDto(wrContent: state.wrContent, wr2: wr2),
              );
        }
        return;
      },
    );
  }

  void _showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(seconds: 1)),
    );
  }
}
