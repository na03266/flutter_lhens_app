// lib/chat/component/chat_message_bubble.dart
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';
import 'package:lhens_app/common/utils/text_break.dart';
import 'package:lhens_app/gen/assets.gen.dart';
import 'package:lhens_app/chat/component/chat_attachment_file.dart';

enum ChatMessageType { text, image, file }

enum ChatMessageSide { left, right }

class ChatMessageBubble extends StatelessWidget {
  final ChatMessageType type;
  final ChatMessageSide side;
  final String? text;
  final String? imageUrl;
  final String? fileName;
  final String? time;
  final int? readCount;

  // ⬇️ 추가: 파일 미리보기/다운로드 콜백
  final VoidCallback? onFilePreview;
  final VoidCallback? onFileDownload;

  const ChatMessageBubble({
    super.key,
    required this.type,
    required this.side,
    this.text,
    this.imageUrl,
    this.fileName,
    this.time,
    this.readCount,
    this.onFilePreview,
    this.onFileDownload,
  });

  @override
  Widget build(BuildContext context) {
    final isRight = side == ChatMessageSide.right;

    Widget content;
    switch (type) {
      case ChatMessageType.text:
        final display = insertWrapHints(text ?? '', chunk: 8, threshold: 16);

        content = Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: isRight ? AppColors.primarySoft : AppColors.white,
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: LayoutBuilder(
            builder: (context, c) {
              final cap = 294.w;
              final max = c.maxWidth.isFinite
                  ? (c.maxWidth < cap ? c.maxWidth : cap)
                  : cap;

              return ConstrainedBox(
                constraints: BoxConstraints(maxWidth: max),
                child: Text(
                  display,
                  softWrap: true,
                  textAlign: TextAlign.start,
                  textWidthBasis: TextWidthBasis.longestLine,
                  textHeightBehavior: const TextHeightBehavior(
                    applyHeightToFirstAscent: false,
                    applyHeightToLastDescent: false,
                  ),
                  style: AppTextStyles.pr14.copyWith(
                    color: AppColors.text,
                    height: 1.25,
                  ),
                ),
              );
            },
          ),
        );
        break;

      case ChatMessageType.image:
        content = LayoutBuilder(
          builder: (context, c) {
            final double capW = 294.w;
            final double maxW = c.maxWidth.isFinite ? c.maxWidth : capW;
            final double bubbleW = maxW < capW ? maxW : capW;
            const double fallbackRatio = 152 / 182;
            final double bubbleH = bubbleW * fallbackRatio;

            return ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.asset(
                Assets.images.chat.path,
                width: bubbleW,
                height: bubbleH,
                fit: BoxFit.cover,
              ),
            );
          },
        );
        break;

      case ChatMessageType.file:
        content = ChatAttachmentFile(
          filename: fileName ?? '첨부파일',
          onPreview: onFilePreview,
          onDownload: onFileDownload,
        );
        break;
    }

    Widget meta() {
      final hasRead = readCount != null;
      final hasTime = time != null && time!.isNotEmpty;
      if (!hasRead && !hasTime) return const SizedBox.shrink();

      final children = <Widget>[];
      if (hasRead && hasTime) {
        children.add(
          Text(
            '$readCount',
            style: AppTextStyles.psb10.copyWith(color: AppColors.secAccent),
          ),
        );
        children.add(SizedBox(height: 2.h));
        children.add(
          Text(
            time!,
            style: AppTextStyles.pr12.copyWith(color: AppColors.textTer),
          ),
        );
      } else if (hasRead) {
        children.add(
          Text(
            '$readCount',
            style: AppTextStyles.psb10.copyWith(color: AppColors.secAccent),
          ),
        );
      } else {
        children.add(
          Text(
            time!,
            style: AppTextStyles.pr12.copyWith(color: AppColors.textTer),
          ),
        );
      }

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: isRight
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: children,
        ),
      );
    }

    return Row(
      mainAxisAlignment: isRight
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: isRight
          ? [meta(), Flexible(fit: FlexFit.loose, child: content)]
          : [Flexible(fit: FlexFit.loose, child: content), meta()],
    );
  }
}
