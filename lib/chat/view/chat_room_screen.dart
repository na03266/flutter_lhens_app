import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lhens_app/chat/component/chat_input_bar.dart';
import 'package:lhens_app/chat/component/chat_message_bubble.dart';
import 'package:lhens_app/chat/component/chat_message_group.dart';
import 'package:lhens_app/chat/component/chat_upload_bubbles.dart';
import 'package:lhens_app/chat/model/message_model.dart';
import 'package:lhens_app/chat/provider/chat_room_provider.dart';
import 'package:lhens_app/chat/repository/chat_socket.dart';
import 'package:lhens_app/common/components/sheets/action_sheet.dart';
import 'package:lhens_app/common/components/dialogs/confirm_dialog.dart';
import 'package:lhens_app/common/theme/app_colors.dart';

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
  final List<_GroupData> _groups = [];

  @override
  void initState() {
    super.initState();
    _seedDemo();
    ref.read(chatRoomProvider.notifier).getDetail(id: widget.id);
    // 1) 입장 시 소켓 join-room
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final gateway = ref.read(chatGatewayClientProvider);
      gateway?.joinRoom(int.parse(widget.id));

      // 2) 메시지 스트림 구독
      gateway?.messages.listen((event) {
        if (event['roomId'] != int.parse(widget.id)) return;
        final msg = MessageModel.fromJson(event);
        setState(() {
          // _messages.add(msg);
        });
      });
    });
  }

  void _seedDemo() {
    _groups
      ..add(
        _GroupData(
          side: ChatMessageSide.left,
          userName: 'LH E&S 기획팀',
          messages: [
            _MsgData.text('댓글 내용\n예시입니다.', read: 2),
            _MsgData.text('ㅋㅋㅋㅋㅋㅋㅋ', read: 2),
            _MsgData.text(
              '댓글 예시 테스트중입니다. 문장이 길어질 경우',
              time: '오후 03:15',
              read: 2,
            ),
          ],
        ),
      )
      ..add(
        _GroupData(
          side: ChatMessageSide.right,
          messages: [
            _MsgData.text('ㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋ', read: 1),
            _MsgData.text('ㅋㅋㅋㅋㅋㅋㅋ', read: 1),
            _MsgData.text('ㅎ', time: '오후 03:15', read: 1),
          ],
        ),
      )
      ..add(
        _GroupData(
          side: ChatMessageSide.left,
          userName: 'LH E&S 기획팀',
          messages: [
            _MsgData.image(time: '오후 03:18', read: 1),
            _MsgData.file('파일이름이길어질경우테스트중.pdf', time: '오후 03:20', read: 1),
          ],
        ),
      )
      ..add(
        _GroupData(
          side: ChatMessageSide.right,
          messages: [
            _MsgData.uploadImage(
              localThumbPath: 'assets/images/chat.png',
              progress: 0.72,
            ),
            _MsgData.uploadFile('업로드중_파일.pdf', progress: 0.3),
            _MsgData.uploadFile('업로드_실패파일이름명테스트.pdf', failed: true),
            _MsgData.uploadImage(
              localThumbPath: 'assets/images/bg_complete.png',
              failed: true,
            ),
            _MsgData.uploadText('전송 실패 텍스트 메시지 예시입니다.', failed: true),
            _MsgData.uploadText('전송 중 텍스트 메시지 예시입니다.', progress: 0.4),
          ],
        ),
      );
  }

  // 중복 제거 로직 공통화
  void _removeMsg(_GroupData g, _MsgData msg, int gi) {
    setState(() {
      g.messages.remove(msg);
      if (g.messages.isEmpty) _groups.removeAt(gi);
    });
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

    final items = <Widget>[];
    for (int gi = 0; gi < _groups.length; gi++) {
      final g = _groups[gi];

      final msgWidgets = <Widget>[];
      for (int mi = 0; mi < g.messages.length; mi++) {
        final m = g.messages[mi];

        final bubble = switch (m.kind) {
          _MsgKind.text => ChatMessageBubble(
            type: ChatMessageType.text,
            side: g.side,
            text: m.text,
            time: m.time,
            readCount: m.read,
          ),
          _MsgKind.image => ChatMessageBubble(
            type: ChatMessageType.image,
            side: g.side,
            time: m.time,
            readCount: m.read,
          ),
          _MsgKind.file => ChatMessageBubble(
            type: ChatMessageType.file,
            side: g.side,
            fileName: m.text,
            time: m.time,
            readCount: m.read,
            onFilePreview: () => _onFilePreview(m.text!),
            onFileDownload: () => _onFileDownload(m.text!),
          ),
          _MsgKind.uploadImage => (() {
            final msgRef = m;
            return UploadImageMessage(
              localThumbPath: m.text ?? 'assets/images/chat.png',
              state: m.failed == true
                  ? UploadState.failed
                  : UploadState.uploading,
              progress: m.progress,
              onCancel: () async {
                final go = await _confirmCancelSend();
                if (!mounted || !go) return;
                _removeMsg(g, msgRef, gi);
              },
              onRetry: () {
                // TODO: 재업로드 로직
              },
            );
          })(),
          _MsgKind.uploadFile => (() {
            final msgRef = m;
            return UploadFileMessage(
              fileName: m.text ?? '파일',
              state: m.failed == true
                  ? UploadState.failed
                  : UploadState.uploading,
              progress: m.progress,
              onCancel: () async {
                final go = await _confirmCancelSend();
                if (!mounted || !go) return;
                _removeMsg(g, msgRef, gi);
              },
              onRetry: () {
                // TODO: 재업로드 로직
              },
            );
          })(),
          _MsgKind.uploadText => (() {
            final msgRef = m;
            return UploadTextMessage(
              text: m.text ?? '',
              state: m.failed == true
                  ? UploadState.failed
                  : UploadState.uploading,
              onCancel: () async {
                final go = await _confirmCancelSend();
                if (!mounted || !go) return;
                _removeMsg(g, msgRef, gi);
              },
              onRetry: () {
                // TODO: 텍스트 재전송 로직
              },
            );
          })(),
        };

        msgWidgets.add(
          _wrapDeletable(
            child: bubble,
            onDelete: () {
              g.messages.removeAt(mi);
              if (g.messages.isEmpty) _groups.removeAt(gi);
            },
          ),
        );
      }

      items.add(
        ChatMessageGroup(
          side: g.side,
          userName: g.userName,
          messages: msgWidgets,
        ),
      );
      if (gi != _groups.length - 1) items.add(SizedBox(height: 16.h));
    }

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
                  controller: _scroll,
                  reverse: true,
                  physics: const ClampingScrollPhysics(),
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: EdgeInsets.fromLTRB(hpad, 16.h, hpad, 16.h),
                  children: items.reversed.toList(),
                ),
              ),
              ChatInputBar(
                controller: _controller,
                onSend: () => _controller.clear(),
                onAttach: _showAttachSheet,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _MsgKind { text, image, file, uploadImage, uploadFile, uploadText }

class _MsgData {
  final _MsgKind kind;
  final String? text;
  final String? time;
  final int? read;
  final double? progress;
  final bool? failed;

  _MsgData._(
    this.kind, {
    this.text,
    this.time,
    this.read,
    this.progress,
    this.failed,
  });

  factory _MsgData.text(String t, {String? time, int? read}) =>
      _MsgData._(_MsgKind.text, text: t, time: time, read: read);

  factory _MsgData.image({String? time, int? read}) =>
      _MsgData._(_MsgKind.image, time: time, read: read);

  factory _MsgData.file(String name, {String? time, int? read}) =>
      _MsgData._(_MsgKind.file, text: name, time: time, read: read);

  factory _MsgData.uploadImage({
    required String localThumbPath,
    double? progress,
    bool failed = false,
  }) => _MsgData._(
    _MsgKind.uploadImage,
    text: localThumbPath,
    progress: progress,
    failed: failed,
  );

  factory _MsgData.uploadFile(
    String name, {
    double? progress,
    bool failed = false,
  }) => _MsgData._(
    _MsgKind.uploadFile,
    text: name,
    progress: progress,
    failed: failed,
  );

  factory _MsgData.uploadText(
    String text, {
    double? progress,
    bool failed = false,
  }) => _MsgData._(
    _MsgKind.uploadText,
    text: text,
    progress: progress,
    failed: failed,
  );
}

class _GroupData {
  final ChatMessageSide side;
  final String? userName;
  final List<_MsgData> messages;

  _GroupData({required this.side, this.userName, required this.messages});
}
