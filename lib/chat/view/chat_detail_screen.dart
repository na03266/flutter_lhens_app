import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';
import 'package:lhens_app/gen/assets.gen.dart';
import 'package:lhens_app/common/components/sheets/action_sheet.dart';

class ChatDetailScreen extends StatefulWidget {
  static String get routeName => '커뮤니케이션 상세';

  const ChatDetailScreen({super.key});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  Future<void> _showAttachSheet() async {
    final sel = await showActionSheet(
      context,
      actions: [
        ActionItem('photo', '사진 선택'),
        ActionItem('file', '파일 선택'),
      ],
    );
    if (!mounted || sel == null) return;
    // TODO: hook image/file pickers if needed. For now, just log.
    debugPrint('[CHAT_ATTACH] selected: $sel');
  }
  final _controller = TextEditingController();
  final _scroll = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hpad = 16.w;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Column(
        children: [
          Expanded(
            child: ListView(
              controller: _scroll,
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(hpad, 16.h, hpad, 16.h),
              children: [
                // 왼쪽(상대) 묶음
                _LeftMessageGroup(
                  userName: 'LH E&S 기획팀',
                  messages: const [
                    _Msg.text('댓글 내용\n예시입니다.'),
                    _Msg.text('ㅋㅋㅋㅋㅋㅋㅋ'),
                    _Msg.text('ㅎ', time: '오후 03:15'),
                  ],
                ),
                SizedBox(height: 16.h),
                // 오른쪽(나) 묶음
                _RightMessageGroup(
                  messages: const [
                    _Msg.text('ㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋ'),
                    _Msg.text('ㅋㅋㅋㅋㅋㅋㅋ'),
                    _Msg.text('ㅎ', time: '오후 03:15'),
                  ],
                ),
                SizedBox(height: 16.h),
                // 왼쪽 이미지 + 파일 예시
                _LeftMessageGroup(
                  userName: 'LH E&S 기획팀',
                  messages: const [
                    _Msg.image('https://placehold.co/182x152', time: '오후 03:18'),
                    _Msg.file('파일예시.pdf', time: '오후 03:20'),
                  ],
                ),
              ],
            ),
          ),

          // 입력 바 (키보드 위 고정)
          _InputBar(
            controller: _controller,
            onSend: () {
              _controller.clear();
            },
            onAttach: _showAttachSheet,
          ),
        ],
      ),
    );
  }
}

class _InputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback onAttach;

  const _InputBar({
    required this.controller,
    required this.onSend,
    required this.onAttach,
  });

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomInset > 0 ? 0 : 0),
        child: Container(
          color: AppColors.white,
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 8.w, 8.h),
          child: Row(
            children: [
              // 첨부 버튼 스타일 사각형
              _SquareIconButton(
                onTap: onAttach,
                child: Assets.icons.clip.svg(width: 20.w, height: 20.w,
                    colorFilter: const ColorFilter.mode(AppColors.text, BlendMode.srcIn)),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Container(
                  height: 48.h,
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    border: Border.all(color: AppColors.border, width: 1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  alignment: Alignment.centerLeft,
                  child: TextField(
                    controller: controller,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => onSend(),
                    decoration: InputDecoration(
                      hintText: '메세지를 입력하세요',
                      hintStyle: AppTextStyles.pm14.copyWith(color: AppColors.placeholder),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: AppTextStyles.pm14.copyWith(color: AppColors.text),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              // 전송 버튼 (연두톤 연한 배경)
              _SquareIconButton(
                onTap: onSend,
                bg: const Color(0x1990C31E),
                child: Icon(Icons.send, size: 18.w, color: AppColors.secondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SquareIconButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final Color? bg;

  const _SquareIconButton({required this.child, required this.onTap, this.bg});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: 32.w,
        height: 32.w,
        decoration: BoxDecoration(
          color: bg ?? AppColors.subtle,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Center(child: child),
      ),
    );
  }
}

class _LeftMessageGroup extends StatelessWidget {
  final String userName;
  final List<_Msg> messages;

  const _LeftMessageGroup({required this.userName, required this.messages});

  @override
  Widget build(BuildContext context) {
    final avatar = Container(
      width: 37.w,
      height: 37.w,
      decoration: BoxDecoration(
        color: AppColors.border,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Center(
        child: Assets.icons.user.svg(width: 20.w, height: 20.w),
      ),
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        avatar,
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(userName,
                  style: AppTextStyles.pm14.copyWith(color: AppColors.text)),
              SizedBox(height: 12.h),
              for (final m in messages) ...[
                _LeftBubble(msg: m),
                SizedBox(height: 12.h),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _RightMessageGroup extends StatelessWidget {
  final List<_Msg> messages;
  const _RightMessageGroup({required this.messages});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 294.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (final m in messages) ...[
                _RightBubble(msg: m),
                SizedBox(height: 12.h),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _LeftBubble extends StatelessWidget {
  final _Msg msg;
  const _LeftBubble({required this.msg});

  @override
  Widget build(BuildContext context) {
    Widget bubble;
    if (msg.type == _MsgType.text) {
      bubble = _textBubble(msg.text!, AppColors.white);
    } else if (msg.type == _MsgType.image) {
      bubble = _imageBubble(msg.imageUrl!);
    } else {
      bubble = _fileBubble(msg.fileName!);
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Flexible(child: bubble),
        if (msg.time != null) ...[
          SizedBox(width: 8.w),
          Text(
            msg.time!,
            style: AppTextStyles.pr12.copyWith(color: AppColors.textTer),
          ),
        ],
      ],
    );
  }
}

class _RightBubble extends StatelessWidget {
  final _Msg msg;
  const _RightBubble({required this.msg});

  @override
  Widget build(BuildContext context) {
    Widget bubble;
    if (msg.type == _MsgType.text) {
      bubble = _textBubble(msg.text!, AppColors.primarySoft);
    } else if (msg.type == _MsgType.image) {
      bubble = _imageBubble(msg.imageUrl!);
    } else {
      bubble = _fileBubble(msg.fileName!);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (msg.time != null) ...[
          Text(
            msg.time!,
            style: AppTextStyles.pr12.copyWith(color: AppColors.textTer),
          ),
          SizedBox(width: 8.w),
        ],
        Flexible(child: bubble),
      ],
    );
  }
}

// 공통 텍스트 버블
Widget _textBubble(String text, Color bg) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
    decoration: BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(8.r),
      border: Border.all(color: AppColors.border, width: 1),
    ),
    child: ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 294.w),
      child: Text(
        text,
        style: AppTextStyles.pr14.copyWith(color: AppColors.text, height: 1.35),
      ),
    ),
  );
}

Widget _imageBubble(String _ignored) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(8.r),
    child: Image.asset(
      Assets.images.chat.path,
      width: 182.w,
      height: 152.h,
      fit: BoxFit.cover,
    ),
  );
}

Widget _fileBubble(String name) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(8.r),
      border: Border.all(color: AppColors.border, width: 1),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 22.w,
          height: 22.w,
          child: Assets.icons.file.svg(width: 18.w, height: 18.w),
        ),
        SizedBox(width: 6.w),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 200.w),
          child: Text(
            name,
            style: AppTextStyles.pr14.copyWith(color: AppColors.text, height: 1.35),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );
}

enum _MsgType { text, image, file }

class _Msg {
  final _MsgType type;
  final String? text;
  final String? imageUrl;
  final String? fileName;
  final String? time;

  const _Msg._(this.type, {this.text, this.imageUrl, this.fileName, this.time});

  const _Msg.text(this.text, {this.time}) : type = _MsgType.text, imageUrl = null, fileName = null;
  const _Msg.image(this.imageUrl, {this.time}) : type = _MsgType.image, text = null, fileName = null;
  const _Msg.file(this.fileName, {this.time}) : type = _MsgType.file, text = null, imageUrl = null;
}
