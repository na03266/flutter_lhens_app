import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:lhens_app/common/components/report/report_list_scaffold.dart';
import 'package:lhens_app/common/components/report/report_list_config.dart';
import 'package:lhens_app/common/components/report/base_report_item_props.dart';
import 'package:lhens_app/common/components/report/report_list_scaffold_v2.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/drawer/complaint/provider/complaint_provider.dart';
import 'package:lhens_app/drawer/complaint/view/complaint_detail_screen.dart';
import 'package:lhens_app/drawer/complaint/view/complaint_form_screen.dart';
import 'package:lhens_app/drawer/model/board_info_model.dart';
import 'package:lhens_app/drawer/model/post_model.dart';
import 'package:lhens_app/drawer/provider/board_provider.dart';
import 'package:lhens_app/gen/assets.gen.dart';
import 'package:lhens_app/mock/complaint/mock_complaint_models.dart';
import 'package:lhens_app/mock/complaint/mock_complaint_data.dart';
import 'package:lhens_app/user/provider/user_me_provier.dart';

import '../../../common/components/report/base_list_item.dart';

class ComplaintScreen extends ConsumerStatefulWidget {
  static String get routeName => '민원제안접수';
  final bool mineOnly; // 내 민원제안 내역
  final bool showFab; // 작성(FAB) 버튼

  const ComplaintScreen({
    super.key,
    this.mineOnly = false,
    this.showFab = true,
  });

  @override
  ConsumerState<ComplaintScreen> createState() => _ComplaintScreenState();
}

class _ComplaintScreenState extends ConsumerState<ComplaintScreen> {
  String caName = '';
  String wr1 = '';
  String title = '';

  @override
  void initState() {
    super.initState();
    ref
        .read(complaintProvider.notifier)
        .paginate(fetchPage: 1, forceRefetch: true);
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

    final me = ref.read(userMeProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: ReportListScaffoldV2<PostModel>(
        tabs: item.boCategoryList.split('|'),
        filters: ['전체', ...item.bo1.split('|')],
        selectTabName: (String selectedTab) {
          setState(() {
            caName = selectedTab.replaceAll(" ", "");
          });
          ref
              .read(complaintProvider.notifier)
              .paginate(fetchPage: 1, caName: selectedTab, forceRefetch: true);
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
          ref
              .read(complaintProvider.notifier)
              .paginate(fetchPage: 1, caName: caName, wr1: wr1, title: title);
        },
        addPost: () => context.pushNamed(ComplaintFormScreen.routeNameCreate),
        provider: complaintProvider,
        changePage: (int page) {
          ref
              .read(complaintProvider.notifier)
              .paginate(
                fetchPage: page,
                caName: caName,
                wr1: wr1,
                title: title,
              );
        },
        itemBuilder: (_, index, model) {
          return GestureDetector(
            onTap: () {
              context.goNamed(
                ComplaintDetailScreen.routeName,
                pathParameters: {'rid': model.wrId.toString()},
              );
            },
            child: BaseListItem.fromPostModelForComplaint(model: model),
          );
        },
      ),
    );

    // return ReportListScaffold<ComplaintItem>(
    //   config: config,
    //   mineOnly: widget.mineOnly,
    // );
  }
}
