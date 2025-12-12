import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lhens_app/chat/component/chat_input_bar.dart';
import 'package:lhens_app/chat/component/chat_message_bubble.dart';
import 'package:lhens_app/chat/component/chat_message_group.dart';
import 'package:lhens_app/chat/model/message_model.dart';
import 'package:lhens_app/chat/provider/chat_message_provider.dart';
import 'package:lhens_app/chat/provider/chat_room_provider.dart';
import 'package:lhens_app/chat/repository/chat_socket.dart';
import 'package:lhens_app/common/components/dialogs/confirm_dialog.dart';
import 'package:lhens_app/common/components/sheets/action_sheet.dart';
import 'package:lhens_app/common/model/cursor_pagination_model.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/user/model/user_model.dart';
import 'package:lhens_app/user/provider/user_me_provier.dart';

class ChatRoomScreen extends ConsumerStatefulWidget {
  static String get routeName => '채팅방';
  final String id;

  const ChatRoomScreen({super.key, required this.id});

  @override
  ConsumerState<ChatRoomScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends ConsumerState<ChatRoomScreen> {
  final _controller = TextEditingController();
  final _scroll = ScrollController();
  final ScrollController controller = ScrollController();

  late final StreamSubscription _msgSub;

  @override
  void initState() {
    super.initState();
    ref.read(chatRoomProvider.notifier).getDetail(id: widget.id);
    controller.addListener(listener);

    // 1) 입장 시 소켓 join-room
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final gateway = ref.read(chatGatewayClientProvider);
      gateway?.joinRoom(int.parse(widget.id));

      // 메시지 수신 스트림 구독
      _msgSub =
          gateway?.messages.listen((event) {
            final msg = MessageModel.fromJson(event);
            print(msg.tempId);

            ref
                .read(chatMessageProvider(widget.id).notifier)
                .addIncomingMessage(msg);
          }) ??
          const Stream.empty().listen((_) {});
    });
  }

  void listener() {
    if (controller.offset > controller.position.maxScrollExtent - 50) {
      ref
          .read(chatMessageProvider(widget.id).notifier)
          .paginate(fetchMore: true);
    }
  }

  // ChatRoomScreen 클래스 안에 private 메서드로 추가
  List<Widget> _buildMessageGroups(List<MessageModel> messages) {
    final me = ref.read(userMeProvider);
    if (me is! UserModel) return [];
    if (messages.isEmpty) return [];

    final List<Widget> groups = [];

    // 현재 그룹 상태
    List<Widget> currentBubbles = [];
    UserModel? currentSender;
    ChatMessageSide? currentSide;
    DateTime? lastDate; // 마지막으로 처리한 날짜(연월일만 비교)

    bool isSameDay(DateTime a, DateTime b) =>
        a.year == b.year && a.month == b.month && a.day == b.day;

    // 날짜 칩(00월 00일) 위젯
    Widget buildDateChip(DateTime d) {
      final label = '${d.year}년 ${d.month}월 ${d.day}일';
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Center(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: AppColors.border, // 필요에 따라 색 조정
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              label,
              style: TextStyle(fontSize: 11.sp, color: AppColors.textTer),
            ),
          ),
        ),
      );
    }

    // 현재까지 쌓인 그룹을 하나 완성해서 groups에 넣는 함수
    void flushCurrentGroup() {
      if (currentBubbles.isEmpty) return;
      groups.add(
        ChatMessageGroup(
          side: currentSide ?? ChatMessageSide.left,
          user: currentSide == ChatMessageSide.left ? currentSender : null,
          messages: currentBubbles,
        ),
      );
      groups.add(SizedBox(height: 16.h));
      currentBubbles = [];
      currentSender = null;
      currentSide = null;
    }

    // 2) 반복 돌면서 바로 이전 메시지와 비교
    for (final m in messages) {
      // 2-1. 날짜 경계 체크 (SYSTEM이든 TEXT든 공통)
      final created = DateTime.tryParse(m.createdAt)?.toLocal();
      if (created != null) {
        final dateOnly = DateTime(created.year, created.month, created.day);
        if (lastDate == null || !isSameDay(lastDate, dateOnly)) {
          // 날짜가 바뀐 시점 → 이전 그룹 마무리 후 날짜 칩 추가
          flushCurrentGroup();
          groups.add(buildDateChip(dateOnly));
          lastDate = dateOnly;
        }
      }

      // 2-2. 시스템 메시지는 가운데 한 줄
      if (m.type == MessageType.SYSTEM) {
        // 혹시 그룹이 진행 중이면 먼저 마무리
        flushCurrentGroup();

        groups.add(
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Center(
              child: Text(
                m.content,
                style: TextStyle(fontSize: 12.sp, color: AppColors.textTer),
              ),
            ),
          ),
        );
        continue;
      }

      // 2-3. 일반 메시지 그룹핑
      final side = me.mbNo == m.author?.mbNo
          ? ChatMessageSide.right
          : ChatMessageSide.left;
      final sender = m.author;

      final sameGroup = (currentSide == side && currentSender == sender);

      if (!sameGroup && currentBubbles.isNotEmpty) {
        // 이전 그룹 마무리
        flushCurrentGroup();
      }

      currentSide = side;
      currentSender = sender;

      // 버블 생성
      final time = _formatTime(m.createdAt);

      Widget bubble;
      if (m.type == MessageType.FILE) {
        bubble = ChatMessageBubble(
          type: ChatMessageType.file,
          side: side,
          fileName: m.content,
          time: time,
          readCount: null,
          onFilePreview: () => _onFilePreview(m.content),
          onFileDownload: () => _onFileDownload(m.content),
        );
      } else if (m.type == MessageType.IMAGE) {
        bubble = ChatMessageBubble(
          type: ChatMessageType.image,
          side: side,
          time: time,
          readCount: null,
        );
      } else {
        bubble = ChatMessageBubble(
          type: ChatMessageType.text,
          side: side,
          text: m.content,
          time: time,
          readCount: null,
        );
      }

      currentBubbles.add(
        _wrapDeletable(
          child: bubble,
          onDelete: () async {
            final ok = await _confirmDelete();
            if (!ok) return;
            ref
                .read(chatMessageProvider(widget.id).notifier)
                .deleteMessage(m.id);
          },
        ),
      );
    }

    // 마지막 그룹 정리
    flushCurrentGroup();

    // 마지막에 SizedBox가 남아있으면 정리
    if (groups.isNotEmpty && groups.last is SizedBox) {
      groups.removeLast();
    }

    return groups;
  }

  String _formatTime(String iso) {
    final dt = DateTime.tryParse(iso);
    if (dt == null) return '';

    final h = dt.toLocal().hour;
    final m = dt.toLocal().minute.toString().padLeft(2, '0');
    final isPm = h >= 12;
    final h12 = h == 0 ? 12 : (h > 12 ? h - 12 : h);
    return '${isPm ? '오후' : '오전'} $h12:$m';
  }

  Future<void> _showAttachSheet() async {
    final sel = await showActionSheet(
      context,
      actions: [ActionItem('photo', '사진 선택'), ActionItem('file', '파일 선택')],
    );
    if (!mounted || sel == null) return;
    debugPrint('[CHAT_ATTACH] selected: $sel');
  }

  @override
  void dispose() {
    _controller.dispose();
    _scroll.dispose();
    _msgSub.cancel();
    super.dispose();
  }

  Future<bool> _confirmDelete() async {
    final key = await showActionSheet(
      context,
      actions: [ActionItem('delete', '메시지 삭제', destructive: true)],
      cancelText: '취소',
    );
    if (!mounted || key != 'delete') return false;

    final ok = await ConfirmDialog.show(
      context,
      title: '삭제',
      message: '이 메시지를\n모두에게서 삭제하시겠습니까?',
      destructive: true,
    );
    if (!mounted) return false;
    return ok == true;
  }

  Future<bool> _confirmCancelSend() async {
    final ok = await ConfirmDialog.show(
      context,
      title: '전송 취소',
      message: '전송을 취소하시겠습니까?',
      destructive: true,
    );
    return ok == true;
  }

  void _onFilePreview(String name) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('미리보기 선택됨: $name')));
  }

  Future<void> _onFileDownload(String name) async {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('다운로드 선택됨: $name')));
  }

  Widget _wrapDeletable({
    required Widget child,
    required VoidCallback onDelete,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onLongPress: () async {
        final go = await _confirmDelete();
        if (!mounted || !go) return;
        setState(onDelete);
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final hpad = 16.w;
    final state = ref.watch(chatMessageProvider(widget.id));

    // 로딩
    if (state is CursorPaginationLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // 에러
    if (state is CursorPaginationError) {
      return Center(child: Text(state.message));
    }
    if (state is! CursorPagination<MessageModel>) {
      // 방어 로직
      return const SizedBox.shrink();
    }

    final messages = state.data;
    final items = _buildMessageGroups(messages);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.bg,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: AnimatedPadding(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  controller: controller,
                  reverse: true,
                  physics: const ClampingScrollPhysics(),
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: EdgeInsets.fromLTRB(hpad, 16.h, hpad, 16.h),
                  // reverse: true 이므로 children 순서를 뒤집어 줌
                  children: items.reversed.toList(),
                ),
              ),
              ChatInputBar(
                controller: _controller,
                onSend: () {
                  final text = _controller.text.trim();
                  if (text.isEmpty) return;

                  final gateway = ref.read(chatGatewayClientProvider);
                  final tempId = DateTime.now().millisecondsSinceEpoch
                      .toString();

                  // 1) 소켓 전송
                  gateway?.sendMessage(
                    int.parse(widget.id),
                    text,
                    tempId: tempId,
                  );

                  // 2) 로컬에 먼저 추가
                  final me = ref.read(userMeProvider); // mbNo, 이름 가져오는 곳
                  if (me is UserModel) {
                    ref
                        .read(chatMessageProvider(widget.id).notifier)
                        .addLocalPendingMessage(
                          text: text,
                          tempId: tempId,
                          me: me,
                        );
                  }

                  _controller.clear();
                },
                onAttach: _showAttachSheet,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
