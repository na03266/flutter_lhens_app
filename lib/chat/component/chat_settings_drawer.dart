import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lhens_app/chat/dto/create_chat_room_dto.dart';
import 'package:lhens_app/chat/model/chat_room_detail_model.dart';
import 'package:lhens_app/chat/provider/chat_room_provider.dart';
import 'package:lhens_app/chat/view/chat_lobby_screen.dart';

import 'package:lhens_app/common/components/buttons/app_button.dart';
import 'package:lhens_app/common/components/count_inline.dart';
import 'package:lhens_app/common/components/dialogs/confirm_dialog.dart';
import 'package:lhens_app/common/components/exit_action_button.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';
import 'package:lhens_app/chat/view/chat_name_screen.dart';
import 'package:lhens_app/user/model/user_pick_result.dart';
import 'package:lhens_app/gen/assets.gen.dart';

class ChatSettingsDrawer extends ConsumerStatefulWidget {
  final BuildContext pageContext;
  final String roomId;
  final String groupName;
  final int participantCount; // 서버 전체 참여자 수 (표시 목록과 다를 수 있음)
  final List<String> participants;
  final VoidCallback? onInvite;
  final VoidCallback? onLeave;

  const ChatSettingsDrawer({
    super.key,
    required this.pageContext,
    required this.roomId,
    this.groupName = 'LH E&S 기획팀',
    this.participantCount = 13,
    this.participants = const [
      '홍길동 대리 | 경영지원팀',
      '홍길동 대리 | 경영지원팀',
      '홍길동 대리 | 경영지원팀',
      '홍길동 대리 | 경영지원팀',
      '홍길동 대리 | 경영지원팀',
      '홍길동 대리 | 경영지원팀',
      '홍길동 대리 | 경영지원팀',
      '홍길동 대리 | 경영지원팀',
      '홍길동 대리 | 경영지원팀',
      '홍길동 대리 | 경영지원팀',
      '홍길동 대리 | 경영지원팀',
      '홍길동 대리 | 경영지원팀',
      '홍길동 대리 | 경영지원팀',
    ],
    this.onInvite,
    this.onLeave,
  });

  @override
  ConsumerState<ChatSettingsDrawer> createState() => _ChatSettingsDrawerState();
}

class _ChatSettingsDrawerState extends ConsumerState<ChatSettingsDrawer> {
  @override
  void initState() {
    super.initState();
    ref.read(chatRoomProvider.notifier).getDetail(id: widget.roomId);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final router = GoRouter.of(widget.pageContext);
    // ❗ ref.read는 여기에서만 한 번
    final chatRoomNotifier = ref.read(chatRoomProvider.notifier);

    final state = ref.watch(chatRoomDetailProvider(widget.roomId));
    if (state == null || state is! ChatRoomDetail) {
      return Center(child: CircularProgressIndicator());
    }

    return Drawer(
      backgroundColor: AppColors.white,
      shape: const ContinuousRectangleBorder(),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _HeaderRow(
              title: state.name,
              onEdit: () async {
                // 1) Drawer 먼저 닫고
                Navigator.of(widget.pageContext).pop();

                // 2) 이름 입력 화면으로 이동
                final roomName = await router.pushNamed<String>(
                  ChatNameScreen.routeName,
                  extra: {'initialName': state.name},
                );

                // 3) 여기서는 ref 대신, 위에서 뽑아둔 chatRoomNotifier 사용
                if (roomName == null || roomName.trim().isEmpty) {
                  return;
                }

                await chatRoomNotifier.patchChatRoom(
                  id: widget.roomId,
                  dto: CreateChatRoomDto(name: roomName),
                );
              },
              onClose: () => Navigator.of(widget.pageContext).pop(),
            ),
            Expanded(
              child: ListView(
                physics: const ClampingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 12.h),
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(color: AppColors.border, width: 1),
                        bottom: BorderSide(color: AppColors.border, width: 1),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 24.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CountInline(
                          label: '참여자',
                          count: state.memberCount,
                          suffix: '명',
                          labelColor: AppColors.text,
                          countColor: AppColors.secondary,
                        ),
                        SizedBox(height: 12.h),
                        AppButton(
                          text: '초대하기',
                          type: AppButtonType.outlined,
                          height: 48.h,
                          onTap: () async {
                            // Drawer 닫기
                            Navigator.of(widget.pageContext).pop();

                            // 사용자 선택 화면으로 이동
                            final res = await GoRouter.of(widget.pageContext)
                                .pushNamed<UserPickResult>(
                                  '커뮤니케이션-사용자선택',
                                  extra: {'mode': 'chatInvite'},
                                );

                            // 여기서도 ref X, chatRoomNotifier O
                            if (res != null && res.members.isNotEmpty) {
                              await chatRoomNotifier.patchChatRoom(
                                id: widget.roomId,
                                dto: CreateChatRoomDto(
                                  name: state.name,
                                  teamNos: res.departments,
                                  memberNos: res.members,
                                ),
                              );

                              ScaffoldMessenger.of(
                                widget.pageContext,
                              ).showSnackBar(
                                const SnackBar(
                                  content: Text('초대했습니다.'),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 2.h),
                  ...state.members.map((e) {
                    final isFirst = state.members.first == e;
                    if (isFirst) {
                      return _ParticipantTile(
                        nameAndDept: '${e.name} ${e.mb2} | ${e.department}',
                        isFirst: true,
                      );
                    }
                    return _ParticipantTile(
                      nameAndDept: '${e.name} ${e.mb2} | ${e.department}',
                    );
                  }),
                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: AppColors.border,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 12.h),
                    child: ExitActionButton(
                      label: '채팅방 나가기',
                      icon: const Icon(
                        Icons.exit_to_app,
                        size: 20,
                        color: AppColors.text,
                      ),
                      onTap: () async {
                        final ok = await ConfirmDialog.show(
                          widget.pageContext,
                          title: '채팅방 나가기',
                          message: '이 채팅방에서 나가시겠습니까?',
                          destructive: true,
                          confirmText: '나가기',
                        );
                        if (!widget.pageContext.mounted) return;
                        if (ok == true) {
                          final r = GoRouter.of(widget.pageContext);
                          ref
                              .read(chatRoomProvider.notifier)
                              .exitChatRoom(id: widget.roomId);
                          Navigator.of(widget.pageContext).maybePop();
                          widget.onLeave?.call();
                          r.goNamed(ChatLobbyScreen.routeName);
                          ScaffoldMessenger.of(widget.pageContext).showSnackBar(
                            const SnackBar(
                              content: Text('채팅방에서 나갔습니다.'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: bottomInset),
          ],
        ),
      ),
    );
  }
}

class _HeaderRow extends StatelessWidget {
  final String title;
  final VoidCallback onEdit;
  final VoidCallback onClose;

  const _HeaderRow({
    required this.title,
    required this.onEdit,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54.h,
      padding: EdgeInsets.only(left: 24.w, right: 12.w),
      color: AppColors.white,
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.psb18.copyWith(color: AppColors.text),
            ),
          ),
          GestureDetector(
            onTap: onEdit,
            behavior: HitTestBehavior.opaque,
            child: _SquareIcon(
              child: Assets.icons.edit.svg(
                width: (24.w).clamp(20.0, 28.0),
                height: (24.w).clamp(20.0, 28.0),
              ),
            ),
          ),
          GestureDetector(
            onTap: onClose,
            behavior: HitTestBehavior.opaque,
            child: _SquareIcon(
              child: Assets.icons.close.svg(
                width: (24.w).clamp(20.0, 28.0),
                height: (24.w).clamp(20.0, 28.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SquareIcon extends StatelessWidget {
  final Widget child;

  const _SquareIcon({required this.child});

  @override
  Widget build(BuildContext context) {
    const double hitSize = 40;
    return SizedBox(
      width: hitSize,
      height: hitSize,
      child: Center(child: child),
    );
  }
}

class _ParticipantTile extends StatelessWidget {
  final String nameAndDept;
  final bool isFirst;

  const _ParticipantTile({required this.nameAndDept, this.isFirst = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: isFirst
              ? BorderSide.none
              : const BorderSide(color: AppColors.subtle, width: 1),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
      child: Text(
        nameAndDept,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.pm15.copyWith(color: AppColors.text),
      ),
    );
  }
}
