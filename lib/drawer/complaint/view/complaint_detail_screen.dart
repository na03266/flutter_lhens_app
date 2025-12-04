import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lhens_app/common/components/label_value_line.dart';
import 'package:lhens_app/common/components/report/report_detail_header.dart';
import 'package:lhens_app/common/components/report/report_detail_scaffold.dart';
import 'package:lhens_app/common/components/report/report_detail_scaffold_v2.dart';
import 'package:lhens_app/drawer/complaint/provider/complaint_provider.dart';
import 'package:lhens_app/drawer/model/post_detail_model.dart';
import 'package:lhens_app/drawer/notice/view/notice_form_screen.dart';

class ComplaintDetailScreen extends ConsumerStatefulWidget {
  static String get routeName => '민원제안 상세';
  final String wrId;

  const ComplaintDetailScreen({super.key, required this.wrId});

  @override
  ConsumerState<ComplaintDetailScreen> createState() =>
      _ComplaintDetailScreenState();
}

class _ComplaintDetailScreenState extends ConsumerState<ComplaintDetailScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(complaintProvider.notifier).getDetail(wrId: widget.wrId);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(complaintDetailProvider(widget.wrId));

    if (state == null|| state is! PostDetailModel) {
      return Center(child: CircularProgressIndicator());
    }
    return ReportDetailScaffoldV2.fromModel(
      model: state,
      onUpdate: () {
        context.goNamed(NoticeFormScreen.routeNameUpdate,
          pathParameters: {'rid': widget.wrId},
        );
      },
      postComment: (wrId, dto) {
        ref.read(complaintProvider.notifier).postComment(wrId: wrId, dto: dto);
      },
      postReply: (wrId, coId, dto) {
        ref
            .read(complaintProvider.notifier)
            .postReComment(wrId: wrId, dto: dto, coId: coId);
      },    );
  }
}
