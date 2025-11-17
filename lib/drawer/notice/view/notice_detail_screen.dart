import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lhens_app/common/components/label_value_line.dart';
import 'package:lhens_app/common/components/report/report_detail_header.dart';
import 'package:lhens_app/common/components/report/report_detail_scaffold.dart';
import 'package:lhens_app/common/components/report/report_detail_scaffold_v2.dart';
import 'package:lhens_app/drawer/notice/provider/notice_provider.dart';

import '../model/notice_detail_model.dart';

class NoticeDetailScreen extends ConsumerStatefulWidget {
  static String get routeName => '공지사항 상세';
  final String wrId;

  const NoticeDetailScreen({super.key, required this.wrId});

  @override
  ConsumerState<NoticeDetailScreen> createState() => _NoticeDetailScreenState();
}

class _NoticeDetailScreenState extends ConsumerState<NoticeDetailScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(noticeProvider.notifier).getDetail(wrId: widget.wrId);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(noticeDetailProvider(widget.wrId));

    if (state == null) {
      return Center(child: CircularProgressIndicator());
    }
    final isDetail = state is NoticeDetailModel;
    print(isDetail);
    // return ReportDetailScaffold(
    //   config: ReportDetailConfig(
    //     typeName: isDetail ? state.caName : '공지사항',
    //     title: isDetail ? state.wrSubject : 'asdf',
    //     headerBuilder: (onMore) => ReportDetailHeader(
    //       typeName: isDetail ? state.caName : '공지사항',
    //       title: isDetail ? state.wrSubject : '',
    //       onMoreTap: onMore,
    //     ),
    //     metaRows: [
    //       LabelValueLine.single(
    //         label1: '작성자',
    //         value1: isDetail ? state.wrName : '',
    //       ),
    //       LabelValueLine.single(
    //         label1: '등록일',
    //         value1: isDetail ? state.wrDatetime : '',
    //       ),
    //       LabelValueLine.single(
    //         label1: '조회수',
    //         value1: isDetail ? state.wrHit.toString() : '0',
    //       ),
    //     ],
    //     body: _NoticeBody(html: isDetail ? state.wrContent : ""),
    //     attachments: isDetail
    //         ? state.files.map((e) => e.fileName).toList()
    //         : [],
    //     editRouteName: '공지사항 수정',
    //     showComments: true,
    //     showBackToListButton: true,
    //     onBackToList: () => Navigator.of(context).pop(),
    //   ),
    // );
    return ReportDetailScaffoldV2.fromModel(isDetail ? state : null);
  }
}

class _NoticeBody extends StatelessWidget {
  final String html;

  const _NoticeBody({super.key, required this.html});

  @override
  Widget build(BuildContext context) {
    // HTML이 비어 있을 때 보여줄 기본 텍스트 (선택)
    const fallbackText = "내용이 없습니다. 관리자에게 문의해 주세요.";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [Html(data: (html.isEmpty) ? fallbackText : html)],
    );
  }
}
