import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:lhens_app/common/components/report/report_list_scaffold.dart';
import 'package:lhens_app/common/components/report/report_list_config.dart';
import 'package:lhens_app/common/components/report/report_list_scaffold_v2.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/drawer/survey/component/survey_list_item.dart';
import 'package:lhens_app/drawer/survey/model/survey_model.dart';
import 'package:lhens_app/drawer/survey/provider/survey_model.dart';
import 'package:lhens_app/drawer/survey/view/survey_detail_screen.dart';
import 'package:lhens_app/gen/assets.gen.dart';
import 'package:lhens_app/mock/survey/mock_survey_models.dart';
import 'package:lhens_app/mock/survey/mock_survey_data.dart';

class SurveyScreen extends ConsumerStatefulWidget {
  static String get routeName => '설문조사';
  final bool mineOnly;

  const SurveyScreen({super.key, this.mineOnly = false});

  @override
  ConsumerState<SurveyScreen> createState() => _SurveyScreenState();
}

class _SurveyScreenState extends ConsumerState<SurveyScreen> {
  String caName = '';
  String wr1 = '';
  String title = '';

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: AppColors.white,
      body: ReportListScaffoldV2<SurveyModel>(
        tabs: ['진행', '마감'],
        filters: ['전체'],
        selectTabName: (String selectedTab) {
          setState(() {
            caName = selectedTab.replaceAll(" ", "");
          });
          // ref
          //     .read(noticeProvider.notifier)
          //     .paginate(fetchPage: 1, caName: selectedTab, forceRefetch: true);
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
          // ref
          //     .read(noticeProvider.notifier)
          //     .paginate(fetchPage: 1, caName: caName, wr1: wr1, title: title);
        },
        provider: surveyProvider,
        changePage: (int page) {
          ref
              .read(surveyProvider.notifier)
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
                SurveyDetailScreen.routeName,
                pathParameters: {'rid': model.poId.toString()},
              );
            },
            child: SurveyListItem(
              status: SurveyStatus.closed,
              nameType: SurveyNameType.anonymous,
              title: 'item.title',
              dateRangeText: 'item.dateRangeText',
              target: 'item.target',
              author: 'item.author',
              participated: true,
            ),
          );
        },
      ),
    );
    // final config = ReportListConfig<SurveyItem>(
    //   tabs: const ['진행', '마감'],
    //   filters: const ['전체'],
    //   emptyMessage: (tab, {required bool mineOnly}) {
    //     if (mineOnly) return '참여한 설문이 없습니다.';
    //     return switch (tab) {
    //       2 => '마감된 설문이 없습니다.',
    //       1 => '진행중인 설문이 없습니다.',
    //       _ => '등록된 설문이 없습니다.',
    //     };
    //   },
    //   emptyIconPath: Assets.icons.features.surveyDoc.path,
    //   showFab: false,
    //   detailRouteName: '설문 상세',
    //   myDetailRouteName: '내 설문 상세',
    //   formRouteName: '설문 작성',
    //
    //   load: () async => generateSurveyItems(10),
    //
    //   tabPredicate: (e, tab) => switch (tab) {
    //     1 => e.status == SurveyStatus.ongoing,
    //     2 => e.status == SurveyStatus.closed,
    //     _ => true,
    //   },
    //
    //   searchPredicate: (e, f, q) {
    //     if (q.isEmpty) return true;
    //     final title = e.title.toLowerCase();
    //     final author = e.author.toLowerCase();
    //     final target = e.target.toLowerCase();
    //     return switch (f) {
    //       '작성자' => author.contains(q),
    //       '대상' => target.contains(q),
    //       _ => title.contains(q) || author.contains(q) || target.contains(q),
    //     };
    //   },
    //   mineOnlyPredicate: (e) => e.participated,
    //
    //   itemBuilder: (ctx, item) => SurveyListItem(
    //     status: item.status,
    //     nameType: item.nameType,
    //     title: item.title,
    //     dateRangeText: item.dateRangeText,
    //     target: item.target,
    //     author: item.author,
    //     participated: item.participated,
    //     onTap: () => ctx.pushNamed('설문 상세'),
    //   ),
    // );
    //
    // return ReportListScaffold<SurveyItem>(config: config, mineOnly: mineOnly);
  }
}
