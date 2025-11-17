import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lhens_app/common/components/attachments/attachment_file_row.dart';
import 'package:lhens_app/common/components/comments/comments_section.dart';
import 'package:lhens_app/common/components/dialogs/confirm_dialog.dart';
import 'package:lhens_app/common/components/inputs/inline_action_field.dart';
import 'package:lhens_app/common/components/report/report_detail_header.dart';
import 'package:lhens_app/common/components/report/text_sizer.dart';
import 'package:lhens_app/common/components/sheets/action_sheet.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';
import 'package:lhens_app/drawer/notice/model/notice_detail_model.dart';
import 'package:lhens_app/drawer/notice/model/notice_file_model.dart';
import 'package:lhens_app/mock/comment/mock_comment_data.dart';
import 'package:lhens_app/mock/comment/mock_comment_models.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../drawer/notice/model/notice_comment_model.dart';
import '../label_value_line.dart';

class ReportDetailScaffoldV2 extends StatefulWidget {
  final bool Function()? onUpdate;
  final bool Function()? onDelete;
  final Function()? postComment;
  final Function()? postReply;
  final String wrSubject;
  final String caName;
  final String wrContent;
  final String wrName;
  final String wrDatetime;
  final String wrHit;
  final List<NoticeCommentModel> comments;
  final List<NoticeFileModel> files;

  const ReportDetailScaffoldV2({
    super.key,
    this.onUpdate,
    this.onDelete,
    this.postComment,
    this.postReply,
    this.caName = '',
    this.wrSubject = '',
    this.wrContent = '',
    this.wrName = '',
    this.wrDatetime = '',
    this.wrHit = '',
    this.comments = const [],
    this.files = const [],
  });

  @override
  State<ReportDetailScaffoldV2> createState() => _ReportDetailScaffoldV2State();

  factory ReportDetailScaffoldV2.fromModel(
    NoticeDetailModel? model, {
    bool Function()? onUpdate,
    bool Function()? onDelete,
    Function()? postComment,
    Function()? postReply,
  }) {
    return ReportDetailScaffoldV2(
      onUpdate: onUpdate,
      onDelete: onDelete,
      postComment: postComment,
      postReply: postReply,
      caName: model?.caName ?? '',
      wrSubject: model?.wrSubject ?? '',
      wrContent: model?.wrContent ?? '',
      wrName: model?.wrName ?? '',
      wrDatetime: model?.wrDatetime ?? '',
      wrHit: model?.wrHit.toString() ?? '',
      comments: model?.comments ?? [],
      files: model?.files ?? [],
    );
  }
}

class _ReportDetailScaffoldV2State extends State<ReportDetailScaffoldV2> {
  final _comment = TextEditingController();
  final _inputFocus = FocusNode();

  String? _replyToId;
  String? _replyToName;
  double _scale = 1.0;

  @override
  void dispose() {
    _comment.dispose();
    _inputFocus.dispose();
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
      final ok = widget.onUpdate ?? false;
      if (ok == true && mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('저장되었습니다.')));
      }
      return;
    }

    if (sel == 'delete') {
      final ok = await ConfirmDialog.show(
        context,
        title: '삭제',
        message: '이 게시글을 삭제하시겠습니까?',
        confirmText: '삭제',
        cancelText: '취소',
        destructive: true,
      );
      widget.onDelete?.call();
      if (ok == true && mounted) Navigator.pop(context);
    }
  }

  void handleReplyTap(String id, String name) {
    setState(() {
      _replyToId = id;
      _replyToName = name;
    });
    _inputFocus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final hPad = 16.w;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusScope.of(context).unfocus(),
          child: ScrollConfiguration(
            behavior: const _NoBounceGlowBehavior(),
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 24.h),
              physics: const ClampingScrollPhysics(),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 24.h),

                  ReportDetailHeader(
                    typeName: widget.caName,
                    title: widget.wrSubject,
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
                            value1: widget.wrName,
                          ),
                          LabelValueLine.single(
                            label1: '등록일',
                            value1: widget.wrDatetime,
                          ),
                          LabelValueLine.single(
                            label1: '조회수',
                            value1: widget.wrHit,
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 16.h),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: hPad),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 4.h,
                          ),
                          child: MediaQuery(
                            data: MediaQuery.of(context).copyWith(
                              // 전체 텍스트 스케일 조정 (1.0 = 기본, 1.2 = 20% 확대)
                              textScaler: TextScaler.linear(_scale),
                            ),
                            child: Html(
                              data: widget.wrContent,
                              style: {
                                "img": Style(
                                  margin: Margins.only(bottom: 12),
                                  // maxWidth만 잡아주고 싶으면
                                  // width: Width.auto(),
                                ),
                              },
                              // 기사 링크(관련 기사)는 그대로 브라우저로
                              onLinkTap: (url, _, __) {
                                if (url == null) return;
                                final uri = Uri.parse(url);
                                launchUrl(
                                  uri,
                                  mode: LaunchMode.externalApplication,
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),

                        for (final f in widget.files) ...[
                          AttachmentFileRow(
                            filename: f.fileName,
                            onPreview: () => debugPrint('미리보기: $f'),
                            onDownload: () {
                              final uri = Uri.parse(f.url);
                              launchUrl(
                                uri,
                                mode: LaunchMode.externalApplication,
                              );
                            },
                          ),
                          SizedBox(height: 8.h),
                        ],
                        SizedBox(height: 16.h),
                        const Divider(
                          color: AppColors.border,
                          thickness: 1,
                          height: 1,
                        ),
                        SizedBox(height: 16.h),
                      ],
                    ),
                  ),

                  if (widget.comments.isNotEmpty)
                    CommentsSection(
                      comments: widget.comments
                          .map(
                            (e) => CommentModel(
                              id: e.wrId.toString(),
                              user: e.wrName,
                              time: e.wrDatetime,
                              text: e.wrContent,
                            ),
                          )
                          .toList(),
                      onTapReply: handleReplyTap,
                    ),

                  // if (cfg.showBackToListButton) ...[
                  //   SizedBox(height: 16.h),
                  //   Padding(
                  //     padding: EdgeInsets.symmetric(horizontal: 16.w),
                  //     child: AppButton(
                  //       text: cfg.backButtonLabel,
                  //       onTap: cfg.onBackToList,
                  //       type: AppButtonType.secondary,
                  //     ),
                  //   ),
                  //   SizedBox(height: 24.h),
                  // ],
                ],
              ),
            ),
          ),
        ),
      ),

      bottomNavigationBar: true
          ? SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  16.w,
                  12.h,
                  16.w,
                  MediaQuery.of(context).viewInsets.bottom > 0 ? 8.h : 16.h,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_replyToId != null)
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.subtle,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '@$_replyToName에게 답글',
                              style: AppTextStyles.pr12,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                            icon: Icon(
                              Icons.close_rounded,
                              size: 18.w,
                              color: AppColors.textTer,
                            ),
                            onPressed: () => setState(() {
                              _replyToId = null;
                              _replyToName = null;
                            }),
                          ),
                        ],
                      ),
                    InlineActionField(
                      variant: InlineActionVariant.comment,
                      controller: _comment,
                      focusNode: _inputFocus,
                      hint: _replyToId == null ? '댓글을 입력해주세요.' : '답글을 입력해주세요.',
                      actionText: '등록',
                      onAction: () {
                        final text = _comment.text.trim();
                        if (text.isEmpty) return;
                        setState(() {
                          _comment.clear();
                          _replyToId = null;
                          _replyToName = null;
                        });
                      },
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }
}

class _NoBounceGlowBehavior extends ScrollBehavior {
  const _NoBounceGlowBehavior();

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const ClampingScrollPhysics();
  }
}
