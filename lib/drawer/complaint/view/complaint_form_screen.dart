import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lhens_app/common/components/report/report_form_scaffold_v2.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/drawer/complaint/provider/complaint_provider.dart';
import 'package:lhens_app/drawer/model/board_info_model.dart';
import 'package:lhens_app/drawer/model/post_detail_model.dart';
import 'package:lhens_app/drawer/provider/board_provider.dart';

import 'complaint_detail_screen.dart';
import 'complaint_screen.dart';

class ComplaintFormScreen extends ConsumerStatefulWidget {
  static String get routeNameCreate => '민원제안 생성';

  static String get routeNameUpdate => '민원제안 수정';
  final String? wrId;

  const ComplaintFormScreen({super.key, this.wrId});

  @override
  ConsumerState<ComplaintFormScreen> createState() =>
      _ComplaintFormScreenState();
}

class _ComplaintFormScreenState extends ConsumerState<ComplaintFormScreen> {
  String ca1Name = '';
  String ca2Name = '';
  String ca3Name = '';

  @override
  void initState() {
    super.initState();
    if (widget.wrId != null) {
      ref.read(complaintProvider.notifier).getDetail(wrId: widget.wrId!);
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
      (element) => element.boTable == 'comm20',
    );
    if (widget.wrId != null) {
      final state = ref.watch(complaintDetailProvider(widget.wrId!));
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
              .read(complaintProvider.notifier)
              .patchPost(dto: dto, wrId: state.wrId);
          context.goNamed(
            ComplaintDetailScreen.routeName,
            pathParameters: {'rid': state.wrId.toString()},
          );
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
        final fixed = dto.copyWith(
          wr2: '접수',
          wrOption: dto.caName == '요청(비공개)' ? 'secret' : dto.wrOption,
        );
        ref.read(complaintProvider.notifier).postPost(dto: fixed);
        context.goNamed(ComplaintScreen.routeName);
      },
    );
  }
}
