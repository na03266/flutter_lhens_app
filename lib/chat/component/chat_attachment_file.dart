import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lhens_app/common/components/attachments/attach_surface.dart';
import 'package:lhens_app/common/components/sheets/action_sheet.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';
import 'package:lhens_app/gen/assets.gen.dart';

class ChatAttachmentFile extends StatelessWidget {
  final String filename;
  final VoidCallback? onPreview;
  final VoidCallback? onDownload;
  final bool showDownloadIcon;

  const ChatAttachmentFile({
    super.key,
    required this.filename,
    this.onPreview,
    this.onDownload,
    this.showDownloadIcon = false,
  });

  Future<void> _handleTap(BuildContext context) async {
    if (onPreview != null && onDownload != null) {
      final sel = await showActionSheet(
        context,
        actions: [
          ActionItem('preview', '미리보기'),
          ActionItem('download', '다운로드'),
        ],
      );
      if (sel == 'preview') onPreview?.call();
      if (sel == 'download') onDownload?.call();
    } else {
      (onPreview ?? onDownload)?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final clickable = (onPreview != null) || (onDownload != null);

    final row = Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 22.w,
          height: 22.w,
          child: Assets.icons.clip.svg(width: 18.w, height: 18.w),
        ),
        SizedBox(width: 6.w),
        Flexible(
          fit: FlexFit.loose,
          child: Text(
            filename,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
            textWidthBasis: TextWidthBasis.parent,
            style: AppTextStyles.pr14.copyWith(
              height: 1.35,
              color: AppColors.text,
            ),
          ),
        ),
        if (showDownloadIcon) ...[
          SizedBox(width: 6.w),
          Assets.icons.download.svg(
            width: 18.w,
            height: 18.w,
            colorFilter: const ColorFilter.mode(
              AppColors.muted,
              BlendMode.srcIn,
            ),
          ),
        ],
      ],
    );

    final content = clickable
        ? GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => _handleTap(context),
            child: row,
          )
        : row;

    return LayoutBuilder(
      builder: (context, c) {
        final cap = 294.w;
        final max = c.maxWidth.isFinite
            ? (c.maxWidth < cap ? c.maxWidth : cap)
            : cap;

        return ConstrainedBox(
          constraints: BoxConstraints(maxWidth: max),
          child: AttachSurface(
            minHeight: 44,
            padding: EdgeInsets.only(
              left: 8.w,
              right: 16.w,
              top: 6.h,
              bottom: 6.h,
            ),
            child: content,
          ),
        );
      },
    );
  }
}
