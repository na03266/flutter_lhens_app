import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lhens_app/chat/component/chat_input_bar.dart';
import 'package:lhens_app/chat/component/chat_message_bubble.dart';
import 'package:lhens_app/chat/component/chat_message_group.dart';
import 'package:lhens_app/chat/model/message_model.dart';
import 'package:lhens_app/chat/model/room_cursor_model.dart';
import 'package:lhens_app/chat/provider/chat_message_provider.dart';
import 'package:lhens_app/chat/provider/chat_room_provider.dart';
import 'package:lhens_app/chat/provider/room_cursor_provider.dart';
import 'package:lhens_app/chat/repository/chat_socket.dart';
import 'package:lhens_app/common/components/dialogs/confirm_dialog.dart';
import 'package:lhens_app/common/components/sheets/action_sheet.dart';
import 'package:lhens_app/common/file/repository/file_repository.dart';
import 'package:lhens_app/common/model/cursor_pagination_model.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/user/model/user_model.dart';
import 'package:lhens_app/user/provider/user_me_provier.dart';
import 'package:url_launcher/url_launcher.dart';

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
  late final StreamSubscription _cursorInitSub;
  late final StreamSubscription _cursorChangedSub;
  bool _isUploadingFile = false;
  bool _initialUnreadOnly = true; // State에 플래그 추가

  @override
  void initState() {
    super.initState();
    ref.read(chatRoomProvider.notifier).getDetail(id: widget.id);
    controller.addListener(listener);

    // 1) 입장 시 소켓 join-room
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final gateway = ref.read(chatGatewayClientProvider);
      gateway?.joinRoom(int.parse(widget.id));

      // 1) 메시지 수신
      _msgSub =
          gateway?.messages.listen((data) {
            final msg = MessageModel.fromJson(data);
            ref
                .read(chatMessageProvider(widget.id).notifier)
                .addIncomingMessage(msg);
          }) ??
          const Stream.empty().listen((_) {});

      // 2) 방 입장 시 전체 커서 스냅샷
      _cursorInitSub =
          gateway?.roomCursors.listen((data) {
            if (data['roomId'].toString() != widget.id) return;
            final cursors = (data['cursors'] as List)
                .map(
                  (e) => RoomCursor(
                    mbNo: e['mbNo'] as int,
                    lastReadId: e['lastReadId'] != null
                        ? (e['lastReadId'].toString())
                        : null,
                  ),
                )
                .toList();
            ref
                .read(roomCursorProvider(widget.id).notifier)
                .setInitial(cursors);
          }) ??
          const Stream.empty().listen((_) {});

      // 3) 특정 유저 커서 변경
      _cursorChangedSub =
          gateway?.cursorUpdates.listen((data) {
            if (data['roomId'].toString() != widget.id) return;
            final mbNo = data['mbNo'] as int;
            final lastReadId = data['lastReadId'] != null
                ? (data['lastReadId'].toString())
                : null;
            ref
                .read(roomCursorProvider(widget.id).notifier)
                .updateCursor(mbNo: mbNo, lastReadId: lastReadId);
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
    // 2) reverse:true 기준, 맨 아래 도달 시 내 커서 업데이트
    if (controller.offset <= 0) {
      final gateway = ref.read(chatGatewayClientProvider);
      final state = ref.read(chatMessageProvider(widget.id));
      if (gateway != null && state is CursorPagination<MessageModel>) {
        final messages = state.data;
        if (messages.isNotEmpty) {
          final last = messages.last;
          final int lastId = last.id is int
              ? last.id as int
              : int.tryParse(last.id.toString()) ?? 0;

          gateway.updateCursor(int.parse(widget.id), lastReadMessageId: lastId);
        }
      }
    }
  }

  // ChatRoomScreen 클래스 안에 private 메서드로 추가
  List<Widget> _buildMessageGroups(List<MessageModel> messages) {
    final me = ref.read(userMeProvider);
    if (me is! UserModel) return [];
    if (messages.isEmpty) return [];
    // ★ 추가: 이 방(roomId)에 대한 커서 목록
    final cursors = ref.watch(roomCursorProvider(widget.id));
    // room_cursor_provider.dart 에서 List<RoomCursor>를 리턴한다고 가정

    // ★ 추가: 메시지별 안 읽은 사람 수 계산
    int calcUnreadFor(MessageModel m) {
      // 메시지 id를 int로 통일
      final int msgId = m.id is int
          ? m.id as int
          : int.tryParse(m.id.toString()) ?? 0;

      return cursors.where((c) {
        // 1) 나 자신은 안 읽음 수 계산에서 제외
        if (c.mbNo == me.mbNo) return false;

        // 2) 아직 한 번도 읽은 적 없는 유저(lastReadId == null)
        if (c.lastReadId == null) return true;

        // 3) 커서 문자열을 int로 파싱
        final int? lastId = int.tryParse(c.lastReadId!);
        if (lastId == null) {
          // 파싱 실패 시 일단 "안 읽음"으로 처리
          return true;
        }

        // 4) 커서가 이 메시지보다 작으면 아직 안 읽은 것
        return lastId < msgId;
      }).length;
    }

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
      int? readCount;
      readCount = calcUnreadFor(m);

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
          readCount: readCount == 0 ? null : readCount,
          onFileDownload: () =>
              _onFileDownload(fileUrl: m.filePath, fileName: m.content),
        );
      } else if (m.type == MessageType.IMAGE) {
        bubble = ChatMessageBubble(
          type: ChatMessageType.image,
          imageUrl: m.filePath,
          side: side,
          time: time,
          readCount: readCount == 0 ? null : readCount,
          onFileDownload: () =>
              _onFileDownload(fileUrl: m.filePath, fileName: m.content),
        );
      } else {
        bubble = ChatMessageBubble(
          type: ChatMessageType.text,
          side: side,
          text: m.content,
          time: time,
          readCount: readCount == 0 ? null : readCount,
        );
      }

      currentBubbles.add(
        _wrapDeletable(
          child: bubble,
          onDelete: () async {
            await ref
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
    if (_isUploadingFile) {
      // 이미 업로드 중이면 그냥 무시하거나, 안내만 띄워도 됨
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('파일 업로드가 끝난 후 다시 시도해 주세요.')));
      return;
    }

    final sel = await showActionSheet(
      context,
      actions: [ActionItem('photo', '사진 선택'), ActionItem('file', '파일 선택')],
    );
    if (!mounted || sel == null) return;
    switch (sel) {
      case 'photo':
        await _pickAndSendFile(FileType.image);
        break;
      case 'file':
        await _pickAndSendFile(FileType.any);
        break;
    }
  }

  Future<void> _pickAndSendFile(FileType type) async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false, // 채팅은 보통 한 번에 1개씩
      type: type,
    );

    if (result == null || result.files.isEmpty) return;

    final platformFile = result.files.first;
    if (platformFile.path == null) return;

    try {
      setState(() {
        _isUploadingFile = true; // 업로드 시작
      });
      final file = File(platformFile.path!);

      // 1) 파일 업로드 (기존 fileRepository 사용)
      final uploadedFile = await ref
          .read(fileRepositoryProvider)
          .uploadChatFile(file: file);

      // 2) 채팅 메시지로 전송
      await _sendFileMessage(
        fileName: platformFile.name,
        fileUrl: uploadedFile ?? '',
        fileType: type,
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('파일 업로드 중 오류가 발생했습니다.')));
    } finally {
      if (mounted) {
        setState(() {
          _isUploadingFile = false; // 업로드 종료
        });
      }
    }
  }

  Future<void> _sendFileMessage({
    required String fileName,
    required String fileUrl,
    required FileType fileType,
  }) async {
    final gateway = ref.read(chatGatewayClientProvider);
    if (gateway == null) return;

    final tempId = DateTime.now().millisecondsSinceEpoch.toString();

    // 1) 소켓 전송
    gateway.sendMessage(
      int.parse(widget.id),
      fileName,
      filePath: fileUrl,
      type: fileType == FileType.any ? MessageType.FILE : MessageType.IMAGE,
      tempId: tempId,
    );

    // 2) 로컬 pending 메시지
    final me = ref.read(userMeProvider);
    if (me is UserModel) {
      ref
          .read(chatMessageProvider(widget.id).notifier)
          .addLocalPendingMessage(
            tempId: tempId,
            me: me,
            text: fileName,
            type: fileType == FileType.any
                ? MessageType.FILE
                : MessageType.IMAGE,
            filePath: fileUrl,
          );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scroll.dispose();
    _msgSub.cancel();
    _cursorInitSub.cancel();
    _cursorChangedSub.cancel();
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

  Future<void> _onFileDownload({
    required String? fileUrl,
    String? fileName,
  }) async {
    // 1) URL 유효성 검사
    if (fileUrl == null || fileUrl.isEmpty) {
      _showSnackBar(context, '파일 경로가 존재하지 않습니다.');
      return;
    }

    final uri = Uri.tryParse(fileUrl);
    if (uri == null) {
      _showSnackBar(context, '잘못된 파일 경로입니다.');
      return;
    }

    try {
      // 2) 실행 가능 여부 확인
      final canLaunch = await canLaunchUrl(uri);
      if (!canLaunch) {
        _showSnackBar(context, '파일을 열 수 있는 앱을 찾지 못했습니다.');
        return;
      }

      // 3) 외부 앱/브라우저에서 열기
      await launchUrl(uri, mode: LaunchMode.externalApplication);

      // 필요하다면, 다운로드 시도 로그를 남기거나 상태 업데이트
      // ex) ref.read(chatMessageProvider.notifier).markFileDownloaded(messageId);
    } catch (e) {
      _showSnackBar(context, '파일을 여는 중 문제가 발생했습니다.');
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _wrapDeletable({
    required Widget child,
    required Future<void> Function() onDelete,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onLongPress: () async {
        final go = await _confirmDelete();
        if (!mounted || !go) return;
        await onDelete();
      },
      child: child,
    );
  }

  void _scrollToMyUnreadPosition(List<MessageModel> messages) {
    if (!_initialUnreadOnly) return; // 이미 한 번 맞췄으면 종료

    final me = ref.read(userMeProvider);
    final cursors = ref.read(roomCursorProvider(widget.id));

    if (me is! UserModel) return;

    final myCursor = cursors.firstWhere(
      (c) => c.mbNo == me.mbNo,
      orElse: () => RoomCursor(mbNo: me.mbNo, lastReadId: null),
    );

    if (myCursor.lastReadId == null) {
      // 커서가 없으면 그냥 최신으로 두고 플래그만 해제
      setState(() {
        _initialUnreadOnly = false;
      });
      return;
    }

    final int lastRead = int.tryParse(myCursor.lastReadId!) ?? 0;

    // 내가 안 읽은 첫 메시지 index
    final index = messages.indexWhere((m) {
      final mid = int.tryParse(m.id.toString());
      return mid != null && mid > lastRead;
    });

    if (index == -1) {
      // 안 읽은 메시지가 없다 → 최신 메시기 기준으로 두고 플래그 해제
      setState(() {
        _initialUnreadOnly = false;
      });
      return;
    }

    // reverse:true 환경에서의 대략적인 offset 계산
    // 메시지 하나당 평균 높이를 80으로 가정 (필요시 조정)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!controller.hasClients) return;

      final double estimatedItemExtent = 80;
      final double targetOffset =
          controller.position.maxScrollExtent - (index * estimatedItemExtent);

      controller.jumpTo(
        targetOffset.clamp(
          controller.position.minScrollExtent,
          controller.position.maxScrollExtent,
        ),
      );

      // 한 번만 실행되도록 플래그 해제
      setState(() {
        _initialUnreadOnly = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final hpad = 16.w;
    final state = ref.watch(chatMessageProvider(widget.id));
    // 커서도 여기서 watch
    ref.watch(roomCursorProvider(widget.id));

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

    // ✅ 최초 1회만, 커서 기준 스크롤 위치 맞추기
    if (_initialUnreadOnly && messages.isNotEmpty) {
      _scrollToMyUnreadPosition(messages);
    }

    // ✅ 메시지는 항상 전체 사용
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
              if (_isUploadingFile)
                Padding(
                  padding: EdgeInsets.only(bottom: 4.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 16.w,
                        height: 16.w,
                        child: const CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        '파일 및 이미지 업로드 중...',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.textTer,
                        ),
                      ),
                    ],
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
