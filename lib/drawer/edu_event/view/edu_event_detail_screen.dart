import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:lhens_app/common/components/label_value_line.dart';
import 'package:lhens_app/common/components/report/report_detail_header.dart';
import 'package:lhens_app/common/components/report/report_detail_scaffold.dart';
import 'package:lhens_app/common/components/report/report_detail_scaffold_v2.dart';
import 'package:lhens_app/drawer/edu_event/provider/edu_provider.dart';
import 'package:lhens_app/drawer/model/post_detail_model.dart';

class EduEventDetailScreen extends ConsumerStatefulWidget {
  static String get routeName => '교육행사 상세';
  final String wrId;

  const EduEventDetailScreen({super.key, required this.wrId});

  @override
  ConsumerState<EduEventDetailScreen> createState() => _EduEventDetailScreenState();
}

class _EduEventDetailScreenState extends ConsumerState<EduEventDetailScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(eduProvider.notifier).getDetail(wrId: widget.wrId);
  }

  @override
  Widget build(BuildContext context,) {
    final state = ref.watch(eduDetailProvider(widget.wrId));

    if (state == null) {
      return Center(child: CircularProgressIndicator());
    }
    final isDetail = state is PostDetailModel;
    return ReportDetailScaffoldV2.fromModel(
      isDetail ? state : null,
    );
  }
}
