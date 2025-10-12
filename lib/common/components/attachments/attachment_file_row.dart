import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lhens_app/common/components/attachments/attach_surface.dart';
import 'package:lhens_app/common/components/sheets/action_sheet.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';
import 'package:lhens_app/gen/assets.gen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lhens_app/common/components/attachments/attach_surface.dart';
import 'package:lhens_app/common/components/sheets/action_sheet.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';
import 'package:lhens_app/gen/assets.gen.dart';

class AttachmentFileRow extends StatelessWidget {
  final String filename;
  final VoidCallback? onPreview; // 미리보기
  final VoidCallback? onDownload; // 다운로드
  final bool showDownloadIcon; // 아이콘 표시

  const AttachmentFileRow({
    super.key,
    required this.filename,
    this.onPreview,
    this.onDownload,
    this.showDownloadIcon = false,
  });

  Future<void> _handleTap(BuildContext context) async {
    // 둘 다 있으면 액션시트
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
      return;
    }
    // 하나만 있으면 해당 동작
    (onPreview ?? onDownload)?.call();
  }

  @override
  Widget build(BuildContext context) {
    final row = Row(
      children: [
        SizedBox(
          width: 24.w,
          height: 24.w,
          child: Assets.icons.clip.svg(width: 20.w, height: 20.w),
        ),
        SizedBox(width: 6.w),
        Expanded(
          child: Text(
            filename,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.pm14.copyWith(color: AppColors.text),
          ),
        ),
        if (showDownloadIcon) ...[
          SizedBox(width: 8.w),
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

    final hasAnyAction = (onPreview != null) || (onDownload != null);

    return AttachSurface(
      height: 48,
      child: hasAnyAction
          ? GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => _handleTap(context),
              child: row,
            )
          : row,
    );
  }
}
