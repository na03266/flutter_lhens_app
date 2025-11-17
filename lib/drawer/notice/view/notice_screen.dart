import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lhens_app/common/components/report/base_list_item.dart';
import 'package:lhens_app/common/components/report/report_list_scaffold_v2.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/drawer/notice/model/notice_model.dart';
import 'package:lhens_app/drawer/notice/provider/notice_provider.dart';

import 'notice_detail_screen.dart';

class NoticeScreen extends ConsumerStatefulWidget {
  static String get routeName => '공지사항';

  const NoticeScreen({super.key});

  @override
  ConsumerState<NoticeScreen> createState() => _NoticeScreenState();
}

class _NoticeScreenState extends ConsumerState<NoticeScreen> {
  String caName = '';
  String wr1 = '';
  String title = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: ReportListScaffoldV2<NoticeModel>(
        tabs: const ['내부 공지사항', '외부 공지사항'],
        filters: const ['전체', '보도자료', '게살버거'],
        selectTabName: (String selectedTab) {
          setState(() {
            caName = selectedTab.replaceAll(" ", "");
          });
          ref
              .read(noticeProvider.notifier)
              .paginate(fetchPage: 1, caName: selectedTab, forceRefetch: true);
        },
        selectFilterName: (String selectedFilter) {
          setState(() {
            wr1 = selectedFilter;
          });
        },
        onSearched: (String input) {
          setState(() {
            title = input;
          });
          ref
              .read(noticeProvider.notifier)
              .paginate(fetchPage: 1, caName: caName, wr1: wr1, title: title);
        },
        addPost: () {},
        provider: noticeProvider,
        changePage: (int page) {
          ref
              .read(noticeProvider.notifier)
              .paginate(
                fetchPage: page,
                caName: caName,
                wr1: wr1,
                title: title,
              );
        },
        itemBuilder: <NoticeModel>(_, index, model) {
          return GestureDetector(
            onTap: () {
              context.goNamed(
                NoticeDetailScreen.routeName,
                pathParameters: {'rid': model.wrId.toString()},
              );
            },
            child: BaseListItem.fromNoticeModel(model: model),
          );
        },
      ),
    );
  }
}
