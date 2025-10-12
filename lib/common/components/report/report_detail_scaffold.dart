import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:lhens_app/common/components/sheets/action_sheet.dart';
import 'package:lhens_app/common/components/text_sizer.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';

import 'package:lhens_app/risk/component/comments_section.dart';
import 'package:lhens_app/mock/comment/mock_comment_data.dart';

import 'package:lhens_app/common/components/attachments/attachment_file_row.dart';
import 'package:lhens_app/common/components/buttons/app_button.dart';

class ReportDetailConfig {
  final String typeName; // (헤더) 유형명
  final String title; // (헤더) 제목
  final List<Widget> metaRows; // 메타 정보
  final Widget body; // 본문 위젯
  final List<String> attachments; // 첨부파일 파일명 리스트
  final String editRouteName; // 일반 수정 라우트
  final String? myEditRouteName; // 마이페이지 플로우 수정 라우트 (옵션)
  final Widget Function(VoidCallback onMore)? headerBuilder; // 헤더 슬롯
  final double? metaGap; // 메타 행 간격

  // 신규 옵션
  final bool showComments; // 댓글 표시 여부
  final bool showBackToListButton; // 하단 "목록으로" 버튼 표시 여부
  final String backButtonLabel; // 버튼 라벨
  final VoidCallback? onBackToList; // 버튼 탭 핸들러

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

  const ReportDetailScaffold({super.key, required this.config});

  @override
  State<ReportDetailScaffold> createState() => _ReportDetailScaffoldState();
}

class _ReportDetailScaffoldState extends State<ReportDetailScaffold> {
  final _comment = TextEditingController();
  double _scale = 1.0;

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  // 헤더 더보기 액션
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
      context.pushNamed(route);
      return;
    }

    if (sel == 'delete') {
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cfg = widget.config;
    final hpad = 16.w;
    final gap = cfg.metaGap ?? 5.h;

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 24.h),

                  // 헤더
                  if (cfg.headerBuilder != null) cfg.headerBuilder!(_onMore),

                  // 글자 크기 조절
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

                  // 메타 정보
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

                  // 본문 + 첨부
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
                          child: DefaultTextStyle.merge(
                            style: AppTextStyles.pr16.copyWith(
                              fontSize: (16.0 * _scale).sp,
                              color: AppColors.text,
                              height: 1.5,
                            ),
                            child: cfg.body,
                          ),
                        ),
                        SizedBox(height: 16.h),

                        // 첨부 파일
                        for (final f in cfg.attachments) ...[
                          AttachmentFileRow(
                            filename: f,
                            // showDownloadIcon: true,
                            onPreview: () => debugPrint('미리보기: $f'),
                            onDownload: () => debugPrint('다운로드: $f'),
                          ),
                          SizedBox(height: 8.h),
                        ],
                      ],
                    ),
                  ),

                  if (cfg.showComments) ...[
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

                    // 댓글
                    CommentsSection(
                      comments: mockComments,
                      controller: _comment,
                      onSend: () => setState(() => _comment.clear()),
                    ),

                    SizedBox(height: 32.h),
                  ],

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
    return child; // 오버스크롤 글로우 제거
  }

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const ClampingScrollPhysics(); // 위/아래 바운스 제거
  }
}
