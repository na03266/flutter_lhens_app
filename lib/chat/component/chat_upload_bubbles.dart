// lib/chat/component/chat_upload_bubbles.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';
import 'package:lhens_app/common/utils/text_break.dart';

enum UploadState { uploading, failed, done, canceled }

const double _fileBubbleMaxW = 248;
const double _chipSize = 22;
const double _chipGap = 4;
const double _groupGap = 8;
const double _metaLaneW = _chipSize + _chipGap + _chipSize;
const double _statusTopGap = 6;
const double _statusHeight = 18;

class UploadFileMessage extends StatelessWidget {
  final String fileName;
  final UploadState state;
  final double? progress;
  final VoidCallback? onCancel;
  final VoidCallback? onRetry;

  const UploadFileMessage({
    super.key,
    required this.fileName,
    required this.state,
    this.progress,
    this.onCancel,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, c) {
        final reserved = _metaLaneW.w + _groupGap.w;
        final maxW = c.maxWidth.isFinite ? c.maxWidth : double.infinity;
        final avail = (maxW - reserved).clamp(0.0, double.infinity);
        final bubbleW = avail.clamp(0.0, _fileBubbleMaxW.w).toDouble();

        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              width: _metaLaneW.w,
              child: _ActionMetaRowLeft(
                state: state,
                onCancel: onCancel,
                onRetry: onRetry,
              ),
            ),
            SizedBox(width: _groupGap.w),
            SizedBox(
              width: bubbleW,
              child: _UploadFileBubbleCore(
                fileName: fileName,
                state: state,
                progress: progress,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _UploadFileBubbleCore extends StatelessWidget {
  final String fileName;
  final UploadState state;
  final double? progress;

  const _UploadFileBubbleCore({
    required this.fileName,
    required this.state,
    this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final bar = ClipRRect(
      borderRadius: BorderRadius.circular(2.r),
      child: LinearProgressIndicator(
        value: state == UploadState.uploading ? progress : null,
        minHeight: 5.h,
        backgroundColor: AppColors.border,
        color: AppColors.secAccent,
      ),
    );

    Widget statusChild;
    if (state == UploadState.uploading) {
      statusChild = Padding(
        padding: EdgeInsets.only(top: 3.h),
        child: bar,
      );
    } else if (state == UploadState.failed) {
      statusChild = Align(
        alignment: Alignment.centerLeft,
        child: Text(
          '업로드 실패',
          style: AppTextStyles.psb12.copyWith(
            color: AppColors.danger,
            height: 1,
          ),
          textHeightBehavior: const TextHeightBehavior(
            applyHeightToFirstAscent: false,
            applyHeightToLastDescent: false,
          ),
        ),
      );
    } else {
      statusChild = const SizedBox.shrink();
    }

    final showStatus =
        state == UploadState.uploading || state == UploadState.failed;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.border, width: 1),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.insert_drive_file_outlined,
                size: 18,
                color: AppColors.muted,
              ),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  fileName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.pr14.copyWith(height: 1),
                ),
              ),
            ],
          ),
          if (showStatus) ...[
            SizedBox(height: _statusTopGap.h),
            SizedBox(
              height: _statusHeight.h,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                child: KeyedSubtree(key: ValueKey(state), child: statusChild),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class UploadImageMessage extends StatefulWidget {
  final String localThumbPath;
  final UploadState state;
  final double? progress;
  final VoidCallback? onCancel;
  final VoidCallback? onRetry;
  final int? originalW;
  final int? originalH;

  const UploadImageMessage({
    super.key,
    required this.localThumbPath,
    required this.state,
    this.progress,
    this.onCancel,
    this.onRetry,
    this.originalW,
    this.originalH,
  });

  @override
  State<UploadImageMessage> createState() => _UploadImageMessageState();
}

class _UploadImageMessageState extends State<UploadImageMessage> {
  double? _ratio;

  @override
  void initState() {
    super.initState();
    if (widget.originalW != null &&
        widget.originalH != null &&
        widget.originalW! > 0) {
      _ratio = widget.originalH! / widget.originalW!;
    } else {
      final ImageStream stream = AssetImage(
        widget.localThumbPath,
      ).resolve(const ImageConfiguration());
      ImageStreamListener? l;
      l = ImageStreamListener(
        (info, _) {
          if (mounted && _ratio == null) {
            final w = info.image.width.toDouble();
            final h = info.image.height.toDouble();
            if (w > 0) setState(() => _ratio = h / w);
          }
          stream.removeListener(l!);
        },
        onError: (_, __) {
          if (mounted) setState(() => _ratio ??= 1.0);
          stream.removeListener(l!);
        },
      );
      stream.addListener(l);
    }
    _ratio ??= 1.0;
  }

  @override
  Widget build(BuildContext context) {
    const double capW = _fileBubbleMaxW;
    const double laneW = _metaLaneW;
    const double laneGap = _groupGap;
    const double maxHCap = 360;

    return LayoutBuilder(
      builder: (ctx, c) {
        final maxW = c.maxWidth.isFinite
            ? c.maxWidth
            : MediaQuery.of(ctx).size.width;
        final avail = (maxW - (laneW + laneGap).w).clamp(0.0, double.infinity);
        final ratio = (_ratio ?? 1.0).clamp(0.2, 4.0);

        double bubbleW = avail.clamp(0.0, capW.w).toDouble();
        double bubbleH = bubbleW * ratio;

        final maxH = maxHCap.h;
        if (bubbleH > maxH) {
          bubbleH = maxH;
          bubbleW = bubbleH / ratio;
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              width: laneW.w,
              child: _ActionMetaRowLeft(
                state: widget.state,
                onCancel: widget.onCancel,
                onRetry: widget.onRetry,
              ),
            ),
            SizedBox(width: laneGap.w),
            SizedBox(
              width: bubbleW,
              height: bubbleH,
              child: _UploadImageBubbleCore(
                localThumbPath: widget.localThumbPath,
                state: widget.state,
                progress: widget.progress,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _UploadImageBubbleCore extends StatelessWidget {
  final String localThumbPath;
  final UploadState state;
  final double? progress;

  const _UploadImageBubbleCore({
    required this.localThumbPath,
    required this.state,
    this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6.r),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: Image.asset(localThumbPath, fit: BoxFit.cover),
          ),
          if (state == UploadState.uploading) ...[
            Positioned.fill(child: Container(color: Colors.black26)),
            _ProgressCircle(progress: progress),
          ],
          if (state == UploadState.failed) ...[
            Positioned.fill(child: Container(color: Colors.black38)),
            Center(
              child: Text(
                '업로드 실패',
                style: AppTextStyles.psb12.copyWith(color: Colors.white),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class UploadTextMessage extends StatelessWidget {
  final String text;
  final UploadState state;
  final double? progress;
  final VoidCallback? onCancel;
  final VoidCallback? onRetry;

  const UploadTextMessage({
    super.key,
    required this.text,
    required this.state,
    this.progress,
    this.onCancel,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, c) {
        final double cap = 294.w;
        final reserved = _metaLaneW.w + _groupGap.w;
        final maxW = c.maxWidth.isFinite
            ? c.maxWidth
            : MediaQuery.of(ctx).size.width;
        final avail = (maxW - reserved).clamp(0.0, double.infinity);
        final bubbleW = avail.clamp(0.0, cap).toDouble();

        final isUploading = state == UploadState.uploading;
        final display = insertWrapHints(text, chunk: 8, threshold: 16);

        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              width: _metaLaneW.w,
              child: _ActionMetaRowLeft(
                state: state,
                onCancel: onCancel,
                onRetry: onRetry,
              ),
            ),
            SizedBox(width: _groupGap.w),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: bubbleW),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  border: Border.all(color: AppColors.border, width: 1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
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
                    color: isUploading ? AppColors.textTer : AppColors.text,
                    height: 1.25,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ActionMetaRowLeft extends StatelessWidget {
  final UploadState state;
  final VoidCallback? onCancel;
  final VoidCallback? onRetry;

  const _ActionMetaRowLeft({required this.state, this.onCancel, this.onRetry});

  @override
  Widget build(BuildContext context) {
    List<Widget> chips;

    switch (state) {
      case UploadState.uploading:
        chips = [
          _IconChip(
            icon: Icons.close,
            onTap: onCancel,
            bg: AppColors.subtle,
            fg: AppColors.textTer,
            size: _chipSize,
          ),
        ];
        break;
      case UploadState.failed:
        chips = [
          _IconChip(
            icon: Icons.refresh,
            onTap: onRetry,
            bg: AppColors.subtle,
            fg: AppColors.text,
            size: _chipSize,
          ),
          SizedBox(width: _chipGap.w),
          _IconChip(
            icon: Icons.close,
            onTap: onCancel,
            bg: const Color(0xFFFCE8E8),
            fg: AppColors.danger,
            size: _chipSize,
          ),
        ];
        break;
      default:
        chips = const [];
    }

    return Align(
      alignment: Alignment.bottomRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: chips,
      ),
    );
  }
}

class _ProgressCircle extends StatelessWidget {
  final double? progress;

  const _ProgressCircle({this.progress});

  @override
  Widget build(BuildContext context) {
    final v = progress?.clamp(0.0, 1.0);
    return SizedBox(
      width: 48.w,
      height: 48.w,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: v,
            strokeWidth: 3,
            backgroundColor: Colors.white24,
            color: AppColors.secondary,
          ),
          if (v != null)
            Text(
              '${(v * 100).round()}%',
              style: AppTextStyles.psb12.copyWith(color: Colors.white),
            ),
        ],
      ),
    );
  }
}

class _IconChip extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final Color bg;
  final Color fg;
  final double size;

  const _IconChip({
    required this.icon,
    this.onTap,
    this.bg = Colors.black38,
    this.fg = Colors.white,
    this.size = 22,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6.r),
        child: Container(
          width: size.w,
          height: size.w,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(6.r),
          ),
          alignment: Alignment.center,
          child: Icon(icon, size: 14, color: fg),
        ),
      ),
    );
  }
}
