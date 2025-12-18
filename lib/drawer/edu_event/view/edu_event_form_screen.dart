import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lhens_app/common/components/report/report_form_scaffold_v2.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/drawer/edu_event/provider/edu_provider.dart';
import 'package:lhens_app/drawer/model/board_info_model.dart';
import 'package:lhens_app/drawer/model/post_detail_model.dart';
import 'package:lhens_app/user/model/user_pick_result.dart';
import 'package:lhens_app/user/model/user_picker_args.dart';

import '../../provider/board_provider.dart';
import 'edu_event_detail_screen.dart';
import 'edu_event_screen.dart';

class EduEventFormScreen extends ConsumerStatefulWidget {
  static String get routeNameCreate => '교육행사 생성';

  static String get routeNameUpdate => '교육행사 수정';
  final String? wrId;

  const EduEventFormScreen({super.key, this.wrId});

  @override
  ConsumerState<EduEventFormScreen> createState() => _EduEventScreenState();
}

class _EduEventScreenState extends ConsumerState<EduEventFormScreen> {
  String ca1Name = '';
  String ca2Name = '';
  String ca3Name = '';

  @override
  void initState() {
    super.initState();
    if (widget.wrId != null) {
      ref.read(eduProvider.notifier).getDetail(wrId: widget.wrId!);
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
      (element) => element.boTable == 'comm22',
    );
    if (widget.wrId != null) {
      final state = ref.watch(eduDetailProvider(widget.wrId!));
      if (state == null || state is! PostDetailModel) {
        return Center(child: CircularProgressIndicator());
      }

      return ReportFormScaffoldV2(
        ca1Names: item.boCategoryList.isNotEmpty
            ? item.boCategoryList.split('|')
            : [],
        ca2Names: item.bo1.isNotEmpty ? item.bo1.split('|') : [],
        submitText: '수정',
        isEduEvent: true,
        post: state,
        onSubmit: (dto) {
          ref.read(eduProvider.notifier).patchPost(wrId: state.wrId, dto: dto);

          context.goNamed(
            EduEventDetailScreen.routeName,
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
      isEduEvent: true,
      onSubmit: (dto) async {
        final res = await GoRouter.of(context).pushNamed<UserPickResult>(
          '커뮤니케이션-사용자선택',
          extra: UserPickerArgs(UserPickerMode.chatCreate),
        );

        if (!context.mounted || res == null) return;

        ref
            .read(eduProvider.notifier)
            .postPost(
              dto: dto.copyWith(
                wr6: res.departments.join(','),
                wr7: res.members.join(','),
              ),
            );

        context.goNamed(EduEventScreen.routeName);
      },
    );
  }
}
