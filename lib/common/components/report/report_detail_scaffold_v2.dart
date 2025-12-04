import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lhens_app/common/components/attachments/attachment_file_row.dart';
import 'package:lhens_app/common/components/comments/comments_section_v2.dart';
import 'package:lhens_app/common/components/dialogs/confirm_dialog.dart';
import 'package:lhens_app/common/components/inputs/inline_action_field.dart';
import 'package:lhens_app/common/components/report/report_detail_header.dart';
import 'package:lhens_app/common/components/report/text_sizer.dart';
import 'package:lhens_app/common/components/sheets/action_sheet.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';
import 'package:lhens_app/common/utils/data_utils.dart';
import 'package:lhens_app/drawer/model/create_post_dto.dart';
import 'package:lhens_app/drawer/model/file_model.dart';
import 'package:lhens_app/drawer/model/post_comment_model.dart';
import 'package:lhens_app/drawer/model/post_detail_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../buttons/app_button.dart';
import '../label_value_line.dart';

class ReportDetailScaffoldV2 extends StatefulWidget {
  final Function()? onUpdate;
  final Function()? onDelete;
  final Function(int, CreatePostDto)? postComment;
  final Function(int, int, CreatePostDto)? postReply;
  final int wrId;
  final String wrSubject;
  final String caName;
  final String wrContent;
  final String wrName;
  final String wrDatetime;
  final String wrHit;
  final String? wr3;
  final String? wr4;
  final List<PostCommentModel> comments;
  final List<FileModel> files;
  final bool showBackToList;
  final bool Function(PostCommentModel c)? canCommentDeleteOf;
  final void Function(PostCommentModel c)? onCommentDelete;
  final Function(int, CreatePostDto c)? onCommentUpdate;

  const ReportDetailScaffoldV2({
    super.key,
    this.onUpdate,
    this.onDelete,
    this.postComment,
    this.postReply,
    required this.wrId,
    this.caName = '',
    this.wrSubject = '',
    this.wrContent = '',
    this.wrName = '',
    this.wrDatetime = '',
    this.wrHit = '',
    this.wr3,
    this.wr4,
    this.comments = const [],
    this.files = const [],
    this.showBackToList = false,
    this.canCommentDeleteOf,
    this.onCommentDelete,
    this.onCommentUpdate,
  });

  @override
  State<ReportDetailScaffoldV2> createState() => _ReportDetailScaffoldV2State();

  factory ReportDetailScaffoldV2.fromModel({
    required PostDetailModel model,
    Function()? onUpdate,
    Function()? onDelete,
    Function(int, CreatePostDto)? postComment,
    Function(int, CreatePostDto)? updateComment,
    Function(int, int, CreatePostDto)? postReply,
    bool Function(PostCommentModel c)? canCommentDeleteOf,
    void Function(PostCommentModel c)? onCommentDelete,
    void Function(int, CreatePostDto c)? onCommentUpdate,
  }) {
    return ReportDetailScaffoldV2(
      onUpdate: onUpdate,
      onDelete: onDelete,
      postComment: postComment,
      postReply: postReply,
      wrId: model.wrId,
      caName: model.caName,
      wrSubject: model.wrSubject,
      wrContent: model.wrContent,
      wrName: model.wrName,
      wrDatetime: model.wrDatetime,
      wrHit: model.wrHit.toString(),
      comments: model.comments,
      files: model.files,
      wr3: model.wr3,
      wr4: model.wr4,
      canCommentDeleteOf: canCommentDeleteOf,
      onCommentDelete: onCommentDelete,
      onCommentUpdate: onCommentUpdate,
    );
  }
}

class _ReportDetailScaffoldV2State extends State<ReportDetailScaffoldV2> {
  final _comment = TextEditingController();
  final _inputFocus = FocusNode();

  int? _replyToId;
  String? _replyToName;
  double _scale = 1.3;
  bool updateReply = false;
  PostCommentModel? replyItem;

  int _pointerCount = 0; // 현재 화면을 누르고 있는 손가락 수
  bool _isMultiTouch = false; // 2개 이상일 때 true

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
        if (widget.onUpdate != null) ActionItem('edit', '수정'),
        if (widget.onDelete != null)
          ActionItem('delete', '삭제', destructive: true),
      ],
    );
    if (!mounted || sel == null) return;

    if (sel == 'edit') {
      widget.onUpdate!();
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

  void handleReplyTap(int id, String name) {
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
      body: Listener(
        onPointerDown: (_) {
          _pointerCount++;
          if (_pointerCount > 1 && !_isMultiTouch) {
            setState(() {
              _isMultiTouch = true; // 두 손가락 이상 눌리면 스크롤 비활성
            });
          }
        },
        onPointerUp: (_) {
          _pointerCount = (_pointerCount - 1).clamp(0, 10);
          if (_pointerCount <= 1 && _isMultiTouch) {
            setState(() {
              _isMultiTouch = false; // 한 손가락 이하가 되면 다시 스크롤 가능
            });
          }
        },
        onPointerCancel: (_) {
          _pointerCount = 0;
          if (_isMultiTouch) {
            setState(() {
              _isMultiTouch = false;
            });
          }
        },
        child: SafeArea(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => FocusScope.of(context).unfocus(),
            child: ScrollConfiguration(
              behavior: const _NoBounceGlowBehavior(),
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 24.h),
                physics: _isMultiTouch
                    ? const NeverScrollableScrollPhysics()
                    : const ClampingScrollPhysics(),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: InteractiveViewer(
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
                              bottom: BorderSide(
                                color: AppColors.border,
                                width: 1,
                              ),
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 4.w,
                            vertical: 20.h,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (widget.wr3 != null && widget.wr3!.isNotEmpty)
                                LabelValueLine.single(
                                  label1: '수신부서',
                                  value1: widget.wr3!,
                                  verticalPadding: EdgeInsets.symmetric(
                                    vertical: 2.h,
                                  ),
                                  labelWidth: 80.w,
                                  labelStyle: AppTextStyles.psb16,
                                  valueStyle: AppTextStyles.pr16,
                                ),

                              if (widget.wr4 != null && widget.wr4!.isNotEmpty)
                                LabelValueLine.single(
                                  label1: '기간',
                                  value1: widget.wr4!,
                                  labelWidth: 80.w,
                                  labelStyle: AppTextStyles.psb16,
                                  valueStyle: AppTextStyles.pr16,
                                  verticalPadding: EdgeInsets.symmetric(
                                    vertical: 2.h,
                                  ),
                                ),
                              LabelValueLine.single(
                                label1: '작성자',
                                value1: widget.wrName,
                                labelWidth: 80.w,
                                labelStyle: AppTextStyles.psb16,
                                valueStyle: AppTextStyles.pr16,
                                verticalPadding: EdgeInsets.symmetric(
                                  vertical: 2.h,
                                ),
                              ),
                              LabelValueLine.single(
                                label1: '등록일',
                                value1: DataUtils.datetimeParse(
                                  widget.wrDatetime,
                                ),
                                labelWidth: 80.w,
                                labelStyle: AppTextStyles.psb16,
                                valueStyle: AppTextStyles.pr16,
                                verticalPadding: EdgeInsets.symmetric(
                                  vertical: 2.h,
                                ),
                              ),
                              LabelValueLine.single(
                                label1: '조회수',
                                value1: widget.wrHit,
                                labelWidth: 80.w,
                                labelStyle: AppTextStyles.psb16,
                                valueStyle: AppTextStyles.pr16,
                                verticalPadding: EdgeInsets.symmetric(
                                  vertical: 2.h,
                                ),
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

                      //댓글및 대댓글
                      if (widget.comments.isNotEmpty)
                        CommentsSectionV2(
                          comments: widget.comments,
                          onTapReply: widget.postReply != null
                              ? handleReplyTap
                              : null,
                          canDeleteOf: widget.canCommentDeleteOf,
                          onDelete: widget.onCommentDelete,
                          onUpdate: (item) {
                            setState(() {
                              _comment.text = item.wrContent;
                              replyItem = item;
                              updateReply = true;
                            });
                          },
                        ),

                      if (!widget.showBackToList) ...[
                        SizedBox(height: 16.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: AppButton(
                            text: '목록으로',
                            onTap: context.pop,
                            type: AppButtonType.secondary,
                          ),
                        ),
                        SizedBox(height: 24.h),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),

      bottomNavigationBar: widget.postComment != null
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
                      actionText: updateReply ? '수정' : '등록',
                      onAction: () {
                        final text = _comment.text.trim();
                        if (updateReply) {
                          final dto = CreatePostDto(wrContent: text);
                          widget.onCommentUpdate!(replyItem!.wrId, dto);
                        } else {
                          if (text.isEmpty) return;
                          final dto = CreatePostDto(wrContent: text);
                          if (_replyToId == null) {
                            widget.postComment!(widget.wrId, dto);
                          } else {
                            widget.postReply!(widget.wrId, _replyToId!, dto);
                          }
                        }
                        setState(() {
                          _comment.clear();
                          _replyToId = null;
                          _replyToName = null;
                          replyItem = null;
                          updateReply = false;
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
