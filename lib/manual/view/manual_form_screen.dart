import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lhens_app/common/components/report/report_form_scaffold_v2.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/drawer/model/board_info_model.dart';
import 'package:lhens_app/drawer/model/post_detail_model.dart';
import 'package:lhens_app/drawer/provider/board_provider.dart';
import 'package:lhens_app/manual/provider/manual_provider.dart';

import 'manual_detail_screen.dart';
import 'manual_screen.dart';


class ManualFormScreen extends ConsumerStatefulWidget {
  static String get routeNameCreate => '메뉴얼 생성';

  static String get routeNameUpdate => '메뉴얼 수정';
  final String? wrId;

  const ManualFormScreen({super.key, this.wrId});

  @override
  ConsumerState<ManualFormScreen> createState() => _ManualScreenState();
}

class _ManualScreenState extends ConsumerState<ManualFormScreen> {
  String ca1Name = '';
  String ca2Name = '';
  String ca3Name = '';

  @override
  void initState() {
    super.initState();
    if (widget.wrId != null) {
      ref.read(manualProvider.notifier).getDetail(wrId: widget.wrId!);
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
      (element) => element.boTable == 'comm10_1',
    );

    if (widget.wrId != null) {
      final state = ref.watch(manualDetailProvider(widget.wrId!));
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
              .read(manualProvider.notifier)
              .patchPost(wrId: state.wrId, dto: dto);
          context.goNamed(
            ManualDetailScreen.routeName,
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
        ref.read(manualProvider.notifier).postPost(dto: dto);
        context.goNamed(ManualScreen.routeName);
      },
    );
  }
}
