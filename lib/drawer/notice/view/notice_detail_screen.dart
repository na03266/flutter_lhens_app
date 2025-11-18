import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lhens_app/common/components/report/report_detail_scaffold_v2.dart';
import 'package:lhens_app/drawer/model/post_detail_model.dart';
import 'package:lhens_app/drawer/notice/provider/notice_provider.dart';


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
    final isDetail = state is PostDetailModel;
    return ReportDetailScaffoldV2.fromModel(
      isDetail ? state : null,
      postComment: () {

      },
    );
  }
}

