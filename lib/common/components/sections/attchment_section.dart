import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lhens_app/common/components/attachment_item.dart';
import 'package:lhens_app/common/components/buttons/attach_button.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';
import 'package:lhens_app/common/theme/app_colors.dart';

class AttachmentSection extends StatelessWidget {
  final List<String> files; // 파일명 리스트
  final VoidCallback onAdd; // 첨부 버튼 탭
  final ValueChanged<String> onRemove; // 파일 제거 콜백
  final double? spacing; // 버튼-리스트 간 간격

  const AttachmentSection({
    super.key,
    required this.files,
    required this.onAdd,
    required this.onRemove,
    this.spacing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 첨부 버튼
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [AttachButton(onTap: onAdd)],
        ),
        SizedBox(height: (spacing ?? 8).h),

        // 파일 리스트 or empty 멘트
        if (files.isEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 4.w),
                child: Text(
                  '첨부된 파일이 없습니다.',
                  style: AppTextStyles.pr14.copyWith(color: AppColors.textTer),
                ),
              ),
              Divider(height: 1, thickness: 1, color: AppColors.border),
            ],
          )
        else
          Column(
            children: [
              for (final name in files)
                AttachmentItem(filename: name, onRemove: () => onRemove(name)),
            ],
          ),
      ],
    );
  }
}
