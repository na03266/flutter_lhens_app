import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:lhens_app/common/components/dialogs/confirm_dialog.dart';
import 'package:lhens_app/common/components/sheets/action_sheet.dart';
import 'package:lhens_app/common/components/text_sizer.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';
import 'package:lhens_app/gen/assets.gen.dart';
import 'package:lhens_app/mock/comment/mock_comment_data.dart';
import 'package:lhens_app/risk/component/comments_section.dart';

class ReportDetailConfig {
  final String typeName;
  final String title;
  final List<Widget> metaRows; // LabelValueLine 등
  final Widget body; // 본문 위젯
  final List<String> attachments; // 파일명 리스트
  final String editRouteName;
  final String? myEditRouteName;

  /// 헤더 주입 슬롯 (예: ReportDetailHeader)
  final Widget Function(VoidCallback onMore)? headerBuilder;

  /// 메타 행 간격(기본 5.h). null이면 기본값 사용.
  final double? metaGap;

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
      final path = GoRouterState
          .of(context)
          .uri
          .path;
      final isMyFlow = path.contains('/my-page/');
      final route = isMyFlow && widget.config.myEditRouteName != null
          ? widget.config.myEditRouteName!
          : widget.config.editRouteName;
      context.pushNamed(route);
      return;
    }

    if (sel == 'delete') {
      final ok = await ConfirmDialog.show(
        context,
        title: '삭제',
        message: '이 글을 삭제하시겠습니까?',
        destructive: true,
      );
      if (ok == true && mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cfg = widget.config;
    final hpad = 16.w;
    final gap = cfg.metaGap ?? 5.h; // 메타 행 간격 기본 5.h

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: const _NoBounceGlowBehavior(),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 24.h),
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 24.h),

                // 헤더: 자체 패딩 포함 컴포넌트를 그대로 렌더 (추가 패딩 금지)
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

                // 메타 정보: 바깥 좌우 16, 내부 좌우 4 + 위아래 20, 하단 보더
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
                      // 본문 컨테이너 내부 좌우 8, 위아래 20
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
                      for (final f in cfg.attachments) ...[
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

                // 댓글
                CommentsSection(
                  comments: mockComments,
                  controller: _comment,
                  onSend: () => setState(() => _comment.clear()),
                ),

                SizedBox(height: 32.h),
              ],
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
      ]
    ];
  }
}

class _NoBounceGlowBehavior extends ScrollBehavior {
  const _NoBounceGlowBehavior();

  @override
  Widget buildOverscrollIndicator(BuildContext context,
      Widget child,
      ScrollableDetails details,) {
    return child; // glow 제거
  }

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const ClampingScrollPhysics(); // bounce 제거
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