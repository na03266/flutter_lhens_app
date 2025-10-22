import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lhens_app/common/components/comments/comments_section.dart';
import 'package:lhens_app/common/components/dialogs/confirm_dialog.dart';
import 'package:lhens_app/common/components/sheets/action_sheet.dart';
import 'package:lhens_app/common/components/report/text_sizer.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';
import 'package:lhens_app/mock/comment/mock_comment_data.dart';
import 'package:lhens_app/common/components/attachments/attachment_file_row.dart';
import 'package:lhens_app/common/components/buttons/app_button.dart';
import 'package:lhens_app/common/components/inputs/inline_action_field.dart';

class ReportDetailConfig {
  final String typeName;
  final String title;
  final List<Widget> metaRows;
  final Widget body;
  final List<String> attachments;
  final String editRouteName;
  final String? myEditRouteName;
  final Widget Function(VoidCallback onMore)? headerBuilder;
  final double? metaGap;

  final bool showComments;
  final bool showBackToListButton;
  final String backButtonLabel;
  final VoidCallback? onBackToList;

  const ReportDetailConfig({
    required this.typeName,
    required this.title,
    required this.metaRows,
    required this.body,
    this.attachments = const [],
    required this.editRouteName,
    this.myEditRouteName,
    this.headerBuilder,
    this.metaGap,
    this.showComments = true,
    this.showBackToListButton = false,
    this.backButtonLabel = '목록으로',
    this.onBackToList,
  });
}

class ReportDetailScaffold extends StatefulWidget {
  final ReportDetailConfig config;

  // 변경: onReplyTap 콜백을 인자로 받는 빌더
  final Widget Function(void Function(String id, String name) onReplyTap)?
  commentsBuilder;

  const ReportDetailScaffold({
    super.key,
    required this.config,
    this.commentsBuilder,
  });

  @override
  State<ReportDetailScaffold> createState() => _ReportDetailScaffoldState();
}

class _ReportDetailScaffoldState extends State<ReportDetailScaffold> {
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
      final path = GoRouterState.of(context).uri.path;
      final isMyFlow = path.contains('/my-page/');
      final route = isMyFlow && widget.config.myEditRouteName != null
          ? widget.config.myEditRouteName!
          : widget.config.editRouteName;

      final ok = await context.pushNamed<bool>(route);
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
      if (ok == true && mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cfg = widget.config;
    final hpad = 16.w;
    final gap = cfg.metaGap ?? 5.h;

    void handleReplyTap(String id, String name) {
      setState(() {
        _replyToId = id;
        _replyToName = name;
      });
      _inputFocus.requestFocus();
    }

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

                  if (cfg.headerBuilder != null) cfg.headerBuilder!(_onMore),

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
                        children: _withGaps(cfg.metaRows, gap),
                      ),
                    ),
                  ),

                  SizedBox(height: 16.h),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: hpad),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 4.h,
                          ),
                          child: DefaultTextStyle.merge(
                            style: AppTextStyles.pr16.copyWith(
                              fontSize: (16.0 * _scale).sp,
                              height: 1.5,
                            ),
                            child: cfg.body,
                          ),
                        ),
                        SizedBox(height: 16.h),

                        for (final f in cfg.attachments) ...[
                          AttachmentFileRow(
                            filename: f,
                            onPreview: () => debugPrint('미리보기: $f'),
                            onDownload: () => debugPrint('다운로드: $f'),
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

                  if (cfg.showComments)
                    (widget.commentsBuilder?.call(handleReplyTap) ??
                        CommentsSection(
                          comments: mockComments,
                          onTapReply: handleReplyTap,
                        )),

                  if (cfg.showBackToListButton) ...[
                    SizedBox(height: 16.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: AppButton(
                        text: cfg.backButtonLabel,
                        onTap: cfg.onBackToList,
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

      bottomNavigationBar: cfg.showComments
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

  List<Widget> _withGaps(List<Widget> rows, double gap) {
    if (rows.isEmpty) return rows;
    return [
      for (int i = 0; i < rows.length; i++) ...[
        rows[i],
        if (i != rows.length - 1) SizedBox(height: gap),
      ],
    ];
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
