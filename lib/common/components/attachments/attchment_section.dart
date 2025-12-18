// lib/common/components/sections/attachment_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lhens_app/common/components/attachments/attachment_item.dart';
import 'package:lhens_app/common/components/attachments/attach_button.dart';
import 'package:lhens_app/common/file/model/file_model.dart';
import 'package:lhens_app/common/file/model/temp_file_model.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';
import 'package:lhens_app/common/theme/app_colors.dart';

class AttachmentSection extends StatelessWidget {
  /// 기존 파일 (서버에서 받은 파일)
  final List<FileModel> oldFiles;

  /// 새로 추가된 파일
  final List<TempFileModel> newFiles;

  /// 첨부 버튼 탭
  final VoidCallback? onAdd;

  /// 기존 파일 제거 콜백 (bfNo로 식별)
  final ValueChanged<int>? onRemoveOld;

  /// 새 파일 제거 콜백 (savedName으로 식별)
  final ValueChanged<String>? onRemoveNew;

  /// 버튼-리스트 간 간격
  final double? spacing;

  /// 읽기 전용(복사/미리보기만, 추가/삭제 불가)
  final bool readOnly;

  /// 완전 비활성(터치 차단)
  final bool enabled;

  const AttachmentSection({
    super.key,
    this.oldFiles = const [],
    this.newFiles = const [],
    this.onAdd,
    this.onRemoveOld,
    this.onRemoveNew,
    this.spacing,
    this.readOnly = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final canMutate = enabled && !readOnly;
    final opacityFor = enabled ? (readOnly ? 0.6 : 1.0) : 0.6;

    final hasFiles = oldFiles.isNotEmpty || newFiles.isNotEmpty;

    return Opacity(
      opacity: opacityFor,
      child: IgnorePointer(
        ignoring: !enabled, // disabled 이면 전체 터치 차단
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 첨부 버튼
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 버튼 자체는 readOnly면 눌리지 않게만
                Opacity(
                  opacity: canMutate ? 1.0 : 0.6,
                  child: IgnorePointer(
                    ignoring: !canMutate,
                    child: AttachButton(onTap: onAdd ?? () {}),
                  ),
                ),
              ],
            ),
            SizedBox(height: (spacing ?? 8).h),

            // 파일 리스트 / empty
            if (!hasFiles)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 16.h,
                      horizontal: 4.w,
                    ),
                    child: Text(
                      '첨부된 파일이 없습니다.',
                      style: AppTextStyles.pr14.copyWith(
                        color: AppColors.textTer,
                      ),
                    ),
                  ),
                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: AppColors.border,
                  ),
                ],
              )
            else
              Column(
                children: [
                  // 기존 파일 목록
                  for (final file in oldFiles)
                    AttachmentItem(
                      filename: file.fileName,
                      onRemove: canMutate && onRemoveOld != null
                          ? () => onRemoveOld!(file.bfNo)
                          : null,
                    ),
                  // 새 파일 목록
                  for (final file in newFiles)
                    AttachmentItem(
                      filename: file.originalName,
                      onRemove: canMutate && onRemoveNew != null
                          ? () => onRemoveNew!(file.savedName)
                          : null,
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
