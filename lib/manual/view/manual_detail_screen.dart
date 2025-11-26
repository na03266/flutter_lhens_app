import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lhens_app/common/components/report/report_detail_scaffold_v2.dart';
import 'package:lhens_app/drawer/model/post_detail_model.dart';
import 'package:lhens_app/drawer/notice/view/notice_form_screen.dart';
import 'package:lhens_app/manual/provider/manual_provider.dart';

class ManualDetailScreen extends ConsumerStatefulWidget {
  static String get routeName => '메뉴얼 상세';
  final String wrId;

  const ManualDetailScreen({super.key, required this.wrId});

  @override
  ConsumerState<ManualDetailScreen> createState() =>
      _ManualDetailScreenState();
}

class _ManualDetailScreenState extends ConsumerState<ManualDetailScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(manualProvider.notifier).getDetail(wrId: widget.wrId);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(manualDetailProvider(widget.wrId));

    if (state == null) {
      return Center(child: CircularProgressIndicator());
    }
    final isDetail = state is PostDetailModel;
    return ReportDetailScaffoldV2.fromModel(
      isDetail ? state : null,
      onUpdate: () {
        context.goNamed(NoticeFormScreen.routeNameUpdate,
          pathParameters: {'rid': widget.wrId},
        );
      },
      postComment: () {},
    );
  }
}
