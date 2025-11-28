import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lhens_app/common/components/report/report_form_scaffold_v2.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/drawer/model/board_info_model.dart';
import 'package:lhens_app/drawer/model/post_detail_model.dart';
import 'package:lhens_app/drawer/notice/provider/notice_provider.dart';

import '../../provider/board_provider.dart';

class NoticeFormScreen extends ConsumerStatefulWidget {
  static String get routeNameCreate => '공지사항 생성';

  static String get routeNameUpdate => '공지사항 수정';
  final String? wrId;

  const NoticeFormScreen({super.key, this.wrId});

  @override
  ConsumerState<NoticeFormScreen> createState() => _NoticeScreenState();
}

class _NoticeScreenState extends ConsumerState<NoticeFormScreen> {
  String ca1Name = '';
  String ca2Name = '';
  String ca3Name = '';

  @override
  void initState() {
    super.initState();
    if (widget.wrId != null) {
      ref.read(noticeProvider.notifier).getDetail(wrId: widget.wrId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final board = ref.watch(boardProvider);
    if (board is! BoardInfo) {
      return Scaffold(
        backgroundColor: AppColors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final item = board.items.firstWhere(
      (element) => element.boTable == 'comm08',
    );
    if (widget.wrId != null) {
      final state = ref.watch(noticeDetailProvider(widget.wrId!));
      if (state == null || state is! PostDetailModel) {
        return Center(child: CircularProgressIndicator());
      }

      return ReportFormScaffoldV2(
        ca1Names: item.boCategoryList.isNotEmpty
            ? item.boCategoryList.split('|')
            : [],
        ca2Names: item.bo1.isNotEmpty ? item.bo1.split('|') : [],
        submitText: '수정',
        post: state,
        onSubmit: (dto) {
          ref
              .read(noticeProvider.notifier)
              .patchPost(wrId: state.wrId, dto: dto);
        },
      );
    }

    return ReportFormScaffoldV2(
      ca1Names: item.boCategoryList.isNotEmpty
          ? item.boCategoryList.split('|')
          : [],
      ca2Names: item.bo1.isNotEmpty ? item.bo1.split('|') : [],
      submitText: '등록',
      onSubmit: (dto) {
        ref.read(noticeProvider.notifier).postPost(dto: dto);
      },
    );
  }
}
