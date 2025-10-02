import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lhens_app/common/components/dialogs/confirm_dialog.dart';

import 'package:lhens_app/common/components/label_value_line.dart';
import 'package:lhens_app/common/components/count_inline.dart';
import 'package:lhens_app/common/components/inputs/inline_action_field.dart';
import 'package:lhens_app/common/components/sheets/action_sheet.dart';
import 'package:lhens_app/common/components/text_sizer.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';
import 'package:lhens_app/gen/assets.gen.dart';
import 'package:lhens_app/risk/component/comment_tile.dart';
import 'package:lhens_app/risk/component/comments_section.dart';

import 'package:lhens_app/risk/component/risk_detail_header.dart';

import 'package:lhens_app/mock/comment/mock_comment_data.dart';
import 'package:lhens_app/mock/comment/mock_comment_models.dart';
import 'package:lhens_app/risk/view/risk_form_screen.dart';

class RiskDetailScreen extends StatefulWidget {
  static String get routeName => '위험신고 상세';

  const RiskDetailScreen({super.key});

  @override
  State<RiskDetailScreen> createState() => _RiskDetailScreenState();
}

class _RiskDetailScreenState extends State<RiskDetailScreen> {
  final _comment = TextEditingController();
  double _scale = 1.0;

  // mock meta
  final _typeName = '신고유형명';
  final _title = '신고 제목이 표시되는 영역입니다. 신고 제목이 표시되는 영역입니다.';
  final _author = '조예빈(1001599)';
  final _dateText = '2025. 08. 28';
  final _statusText = '접수';
  final _openText = '공개';
  final _attachments = const ['첨부파일명.pdf'];

  List<CommentModel> get _comments => mockComments;

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  Future<void> _onMore() async {
    final sel = await showActionSheet(
      context,
      actions: [
        ActionItem('edit', '수정'),
        ActionItem('delete', '삭제', destructive: true),
      ],
    );

    if (!mounted || sel == null) return;

    if (sel == 'edit') {
      context.pushNamed(RiskFormScreen.routeName);
      return;
    }

    if (sel == 'delete') {
      final ok = await ConfirmDialog.show(
        context,
        title: '삭제',
        message: '이 신고를 삭제하시겠습니까?',
        destructive: true,
      );
      if (ok == true && mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hpad = 16.w;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 24.h),

              RiskDetailHeader(
                typeName: _typeName,
                title: _title,
                onMoreTap: _onMore,
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextSizer(
                    value: _scale,
                    onChanged: (v) => setState(() => _scale = v),
                  ),
                ),
              ),

              SizedBox(height: 12.h),

              // meta (bottom border only)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: AppColors.border, width: 1),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 4.w,
                    vertical: 20.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LabelValueLine.single(
                        label1: '작성자',
                        value1: _author,
                        verticalPadding: EdgeInsets.only(bottom: 5.h),
                      ),
                      LabelValueLine.single(
                        label1: '등록일',
                        value1: _dateText,
                        verticalPadding: EdgeInsets.only(bottom: 5.h),
                      ),
                      LabelValueLine.single(
                        label1: '진행상황',
                        value1: _statusText,
                        verticalPadding: EdgeInsets.only(bottom: 5.h),
                      ),
                      LabelValueLine.single(label1: '공개여부', value1: _openText),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 16.h),

              // body + attachments
              Padding(
                padding: EdgeInsets.symmetric(horizontal: hpad),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 20.h,
                      ),
                      child: Text(
                        '내용이 표시되는\n영역입니다.',
                        style: AppTextStyles.pr16.copyWith(
                          fontSize: (16.0 * _scale).sp,
                          color: AppColors.text,
                          height: 1.5,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    for (final f in _attachments) ...[
                      _ReadonlyAttachRow(filename: f),
                      SizedBox(height: 8.h),
                    ],
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: const Divider(
                  color: AppColors.border,
                  thickness: 1,
                  height: 1,
                ),
              ),
              SizedBox(height: 16.h),
              // comments
              CommentsSection(
                comments: _comments,
                controller: _comment,
                onSend: () => setState(() => _comment.clear()),
              ),

              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReadonlyAttachRow extends StatelessWidget {
  final String filename;

  const _ReadonlyAttachRow({required this.filename});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.h,
      padding: EdgeInsets.only(left: 8.w, right: 16.w),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: AppColors.border),
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
      child: Row(
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
        ],
      ),
    );
  }
}
