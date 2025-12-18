import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lhens_app/common/components/report/base_list_item.dart';
import 'package:lhens_app/common/components/report/report_list_scaffold_v2.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/drawer/model/board_info_model.dart';
import 'package:lhens_app/drawer/model/post_model.dart';
import 'package:lhens_app/drawer/provider/board_provider.dart';
import 'package:lhens_app/manual/provider/manual_provider.dart';
import 'package:lhens_app/manual/view/manual_detail_screen.dart';
import 'package:lhens_app/user/model/user_model.dart';
import 'package:lhens_app/user/provider/user_me_provier.dart';

import 'manual_form_screen.dart';

class ManualScreen extends ConsumerStatefulWidget {
  static String get routeName => '업무매뉴얼';

  const ManualScreen({super.key});

  @override
  ConsumerState<ManualScreen> createState() => _ManualScreenState();
}

class _ManualScreenState extends ConsumerState<ManualScreen> {
  String caName = '';
  String wr1 = '';
  String wr2 = '';
  String title = '';

  final TextEditingController _query = TextEditingController();

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
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

    final me = ref.read(userMeProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: ReportListScaffoldV2<PostModel>(
        tabs: item.boCategoryList.split('|'),
        filters: [
          '전체',
          ...item.bo1.split('|').length > 1 ? item.bo1.split('|') : [],
        ],
        selectTabName: (String selectedTab) {
          setState(() {
            caName = selectedTab.replaceAll(" ", "");
          });
          ref
              .read(manualProvider.notifier)
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
              .read(manualProvider.notifier)
              .paginate(fetchPage: 1, caName: caName, wr1: wr1, title: title);
        },
        addPost: me is UserModel && me.mbLevel >= 4
            ? () {
                context.pushNamed(ManualFormScreen.routeNameCreate);
              }
            : null,
        provider: manualProvider,
        changePage: (int page) {
          ref
              .read(manualProvider.notifier)
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
                ManualDetailScreen.routeName,
                pathParameters: {'rid': model.wrId.toString()},
              );
            },
            child: BaseListItem.fromManual(
              model: model,
            ), //BaseListItem.fromPostModelForComplaint(model: model),
          );
        },
      ),
    );
  }
}
