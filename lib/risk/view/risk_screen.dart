import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lhens_app/common/components/report/base_list_item.dart';
import 'package:lhens_app/common/components/report/report_list_scaffold_v2.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/drawer/model/board_info_model.dart';
import 'package:lhens_app/drawer/model/post_model.dart';
import 'package:lhens_app/drawer/provider/board_provider.dart';
import 'package:lhens_app/risk/provider/risk_provider.dart';
import 'package:lhens_app/risk/view/risk_detail_screen.dart';
import 'package:lhens_app/risk/view/risk_form_screen.dart';

class RiskScreen extends ConsumerStatefulWidget {
  static String get routeName => '위험신고';

  final bool mineOnly; // 내 위험신고 내역
  final bool showFab; // 작성(FAB) 버튼 노출

  const RiskScreen({super.key, this.mineOnly = false, this.showFab = true});

  @override
  ConsumerState<RiskScreen> createState() => _RiskScreenState();
}

class _RiskScreenState extends ConsumerState<RiskScreen> {
  String caName = '';
  String wr1 = '';
  String wr2 = '';
  String title = '';

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
      (element) => element.boTable == 'comm21',
    );

    return Scaffold(
      backgroundColor: AppColors.white,
      body: ReportListScaffoldV2<PostModel>(
        mineOnly: widget.mineOnly,
        tabs: item.boCategoryList.split('|'),
        filters: ['전체'],
        selectTabName: (String selectedTab) {
          setState(() {
            caName = selectedTab;
          });
          if (widget.mineOnly) {
            ref
                .read(riskProvider.notifier)
                .paginate(
                  fetchPage: 1,
                  caName: selectedTab,
                  forceRefetch: true,
                  mineOnly: 1,
                );
          } else {
            ref
                .read(riskProvider.notifier)
                .paginate(
                  fetchPage: 1,
                  caName: selectedTab,
                  forceRefetch: true,
                );
          }
        },
        selectFilterName: (String selectedFilter) {
          setState(() {
            if (selectedFilter == '전체') {
              wr1 = '';
            } else {
              wr1 = selectedFilter;
            }
          });
        },
        onSearched: (String input) {
          setState(() {
            title = input;
          });
          if (widget.mineOnly) {
            ref
                .read(riskProvider.notifier)
                .paginate(
                  fetchPage: 1,
                  caName: caName,
                  wr1: wr1,
                  title: title,
                  mineOnly: 1,
                );
          } else {
            ref
                .read(riskProvider.notifier)
                .paginate(fetchPage: 1, caName: caName, wr1: wr1, title: title);
          }
        },
        addPost: () {
          context.goNamed(RiskFormScreen.routeNameCreate);
        },
        provider: riskProvider,
        changePage: (int page) {
          if (widget.mineOnly) {
            ref
                .read(riskProvider.notifier)
                .paginate(
                  fetchPage: page,
                  caName: caName,
                  wr1: wr1,
                  title: title,
                  mineOnly: 1,
                );
          } else {
            ref
                .read(riskProvider.notifier)
                .paginate(
                  fetchPage: page,
                  caName: caName,
                  wr1: wr1,
                  title: title,
                );
          }
        },
        itemBuilder: (_, index, model) {
          return GestureDetector(
            onTap: () {
              context.goNamed(
                RiskDetailScreen.routeName,
                pathParameters: {'rid': model.wrId.toString()},
              );
            },
            child: BaseListItem.fromPostModelForComplaint(model: model),
          );
        },
      ),
    );
  }
}
