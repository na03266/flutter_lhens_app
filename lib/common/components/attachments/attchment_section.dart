// lib/common/components/sections/attachment_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lhens_app/common/components/attachments/attachment_item.dart';
import 'package:lhens_app/common/components/attachments/attach_button.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';
import 'package:lhens_app/common/theme/app_colors.dart';

class AttachmentSection extends StatelessWidget {
  final List<String> files; // 파일명 리스트
  final VoidCallback? onAdd; // 첨부 버튼 탭
  final ValueChanged<String>? onRemove; // 파일 제거 콜백
  final double? spacing; // 버튼-리스트 간 간격

  /// 읽기 전용(복사/미리보기만, 추가/삭제 불가)
  final bool readOnly;

  /// 완전 비활성(터치 차단)
  final bool enabled;

  const AttachmentSection({
    super.key,
    required this.files,
    this.onAdd,
    this.onRemove,
    this.spacing,
    this.readOnly = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final canMutate = enabled && !readOnly;
    final opacityFor = enabled ? (readOnly ? 0.6 : 1.0) : 0.6;

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
            if (files.isEmpty)
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
                  for (final name in files)
                    // 항목별 삭제 버튼은 readOnly면 숨김, enabled=false면 어차피 터치 차단
                    AttachmentItem(
                      filename: name,
                      onRemove: canMutate && onRemove != null
                          ? () => onRemove!(name)
                          : null, // ← null이면 삭제 아이콘 감춤(아래 주석 참고)
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
