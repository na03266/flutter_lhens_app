import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:lhens_app/common/components/label_value_line.dart';
import 'package:lhens_app/common/components/count_inline.dart';
import 'package:lhens_app/common/components/inputs/inline_action_field.dart';
import 'package:lhens_app/common/components/text_sizer.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';
import 'package:lhens_app/gen/assets.gen.dart';
import 'package:lhens_app/risk/component/risk_detail_header.dart';
import 'package:lhens_app/risk/view/risk_form_screen.dart';

class RiskDetailScreen extends StatefulWidget {
  static String get routeName => '위험신고 상세';

  const RiskDetailScreen({super.key});

  @override
  State<RiskDetailScreen> createState() => _RiskDetailScreenState();
}

class _RiskDetailScreenState extends State<RiskDetailScreen> {
  final _comment = TextEditingController();
  double _scale = 1.0; // 글자 배율

  // Mock 데이터 (타입/제목/작성자 등)
  final String _typeName = '신고유형명';
  final String _title =
      '신고 제목이 표시되는 영역입니다. 신고 제목이 표시되는 영역입니다. 신고 제목이 표시되는 영역입니다. 신고 제목이 표시되는 영역입니다. ';
  final String _author = '조예빈(1001599)';
  final String _dateText = '2025. 08. 28';
  final String _statusText = '접수';
  final String _openText = '공개';
  final List<String> _attachments = const ['첨부파일명.pdf'];

  // 간단 댓글 데이터 (중첩 예시)
  final List<_Comment> _comments = [
    _Comment(
      user: '김찬주(1001655)',
      time: '2025. 01. 01. 13:57',
      text: '내용 수정 요청합니다. 사진이 잘 보이지 않습니다.\n파일을 다시 첨부해주세요.',
      replies: [
        _Comment(
          user: '조예빈(1001599)',
          time: '2025. 01. 01. 13:58',
          text: '첨부파일 내용 수정하였습니다. 내용 재확인 부탁드립니다.',
        ),
        _Comment(
          user: '김찬주(1001655)',
          time: '2025. 01. 01. 14:01',
          text: '확인하였습니다. 감사합니다.',
        ),
      ],
    ),
    _Comment(
      user: '김찬주(1001655)',
      time: '2025. 01. 01. 13:57',
      text: '댓글 예시입니다.',
      replies: [
        _Comment(
          user: '조예빈(1001599)',
          time: '2025. 01. 01. 13:58',
          text: '대댓글 예시입니다.',
        ),
      ],
    ),
  ];

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  void _onMore() async {
    final sel = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(9999, 56.h, 8.w, 0),
      items: const [
        PopupMenuItem(value: 'edit', child: Text('수정')),
        PopupMenuItem(value: 'delete', child: Text('삭제')),
      ],
    );
    switch (sel) {
      case 'edit':
        if (!mounted) return;
        context.pushNamed(RiskFormScreen.routeName);
        break;
      case 'delete':
        if (!mounted) return;
        final ok = await showDialog<bool>(
          context: context,
          builder: (c) => AlertDialog(
            title: const Text('삭제'),
            content: const Text('이 신고를 삭제하시겠습니까?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(c, false),
                child: const Text('취소'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(c, true),
                child: const Text('삭제'),
              ),
            ],
          ),
        );
        if (ok == true && mounted) {
          // 실제 삭제 연동 전 임시로 뒤로가기
          context.pop();
        }
        break;
      default:
        break;
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
              // 상단 영역
              RiskDetailHeader(
                typeName: _typeName,
                title: _title,
                onMoreTap: _onMore,
              ),

              // 헤더 바로 아래 오른쪽에 사이저
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
              // 작성자/등록일/진행상황/공개여부
// 메타 정보 (하단 보더만)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: AppColors.border, width: 1),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 20.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LabelValueLine.single(
                        label1: '작성자', value1: _author,
                        labelWidth: 52, verticalPadding: EdgeInsets.only(bottom: 5.h),
                      ),
                      LabelValueLine.single(
                        label1: '등록일', value1: _dateText,
                        labelWidth: 52, verticalPadding: EdgeInsets.only(bottom: 5.h),
                      ),
                      LabelValueLine.single(
                        label1: '진행상황', value1: _statusText,
                        labelWidth: 52, verticalPadding: EdgeInsets.only(bottom: 5.h),
                      ),
                      LabelValueLine.single(
                        label1: '공개여부', value1: _openText,
                        labelWidth: 52,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.h),

              // 본문 + 첨부파일
              Padding(
                padding: EdgeInsets.symmetric(horizontal: hpad),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 본문 (테두리 없음, 패딩만)
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

                    // 첨부파일 표시(읽기 전용)
                    for (final f in _attachments) ...[
                      _ReadonlyAttachRow(filename: f),
                      SizedBox(height: 8.h),
                    ],

                    // 첨부파일 아래 간격
                    SizedBox(height: 24.h),
                  ],
                ),
              ),

              // 댓글 섹션
              Padding(
                padding: EdgeInsets.symmetric(horizontal: hpad - 2.w),
                child: CountInline(label: '댓글', count: _comments.length),
              ),
              SizedBox(height: 12.h),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: hpad),
                child: InlineActionField(
                  variant: InlineActionVariant.comment,
                  controller: _comment,
                  hint: '댓글을 입력해주세요.',
                  onAction: () {
                    // 임시: 입력값 비움
                    setState(() => _comment.clear());
                  },
                ),
              ),
              SizedBox(height: 16.h),

              // 댓글 리스트
              Padding(
                padding: EdgeInsets.symmetric(horizontal: hpad),
                child: Column(
                  children: [
                    for (final c in _comments) ...[
                      _CommentTile(comment: c),
                      SizedBox(height: 8.h),
                    ],
                  ],
                ),
              ),

              SizedBox(height: 72.h), // 바텀 네비와 여백
            ],
          ),
        ),
      ),
    );
  }
}

// 읽기 전용 첨부파일 행 (클립 아이콘 + 파일명)
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

class _CommentTile extends StatelessWidget {
  final _Comment comment;
  final bool nested;

  const _CommentTile({required this.comment, this.nested = false});

  @override
  Widget build(BuildContext context) {
    final avatarBox = Container(
      width: 36.w,
      height: 36.w,
      decoration: BoxDecoration(
        color: AppColors.border,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Center(
        child: SizedBox(width: 24.w, height: 24.w),
      ),
    );

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.subtle, width: 1),
        borderRadius: nested ? null : BorderRadius.circular(0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 16.h, right: 6.w, bottom: 16.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                avatarBox,
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              comment.user,
                              style: AppTextStyles.psb14.copyWith(
                                color: AppColors.textSec,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        comment.text,
                        style: AppTextStyles.pr15.copyWith(
                          color: AppColors.text,
                          height: 1.35,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          Text(
                            comment.time,
                            style: AppTextStyles.pr14.copyWith(
                              color: AppColors.textTer,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            '답글쓰기',
                            style: AppTextStyles.pr14.copyWith(
                              color: AppColors.textTer,
                            ),
                          ),
                          if (!nested) ...[
                            const Spacer(),
                            Text(
                              '삭제',
                              style: AppTextStyles.pr14.copyWith(
                                color: AppColors.textTer,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (comment.replies.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final r in comment.replies)
                  Padding(
                    padding: EdgeInsets.only(left: 32.w),
                    child: _ReplyTile(comment: r),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

class _ReplyTile extends StatelessWidget {
  final _Comment comment;

  const _ReplyTile({required this.comment});

  @override
  Widget build(BuildContext context) {
    final avatarBox = Container(
      width: 36.w,
      height: 36.w,
      decoration: BoxDecoration(
        color: AppColors.border,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Center(
        child: SizedBox(width: 24.w, height: 24.w),
      ),
    );

    return Padding(
      padding: EdgeInsets.only(top: 4.h, right: 6.w, bottom: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          avatarBox,
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        comment.user,
                        style: AppTextStyles.psb14.copyWith(
                          color: AppColors.textSec,
                        ),
                      ),
                    ),
                    Text(
                      '삭제',
                      style: AppTextStyles.pr14.copyWith(
                        color: AppColors.textTer,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                Text(
                  comment.text,
                  style: AppTextStyles.pr15.copyWith(color: AppColors.text),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Text(
                      comment.time,
                      style: AppTextStyles.pr14.copyWith(
                        color: AppColors.textTer,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      '답글쓰기',
                      style: AppTextStyles.pr14.copyWith(
                        color: AppColors.textTer,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Comment {
  final String user;
  final String time;
  final String text;
  final List<_Comment> replies;

  const _Comment({
    required this.user,
    required this.time,
    required this.text,
    this.replies = const [],
  });
}
