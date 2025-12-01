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
              status: _getSurveyStatus(model),
              title: model.poSubject,
              dateRangeText: '${model.poDate} ~ ${model.poDateEnd}',
              author: model.poCnt1.toString(),
              participated: model.isSurvey,
            ),
          );
        },
      ),
    );
  }

  SurveyStatus _getSurveyStatus(SurveyModel model) {
    final now = DateTime.now();

    // 종료일 문자열을 DateTime 으로 변환
    final end = DateTime.parse(model.poDateEnd);

    // 종료일 하루의 끝(23:59:59)까지를 "진행"으로 보고 싶다면
    final endOfDay = DateTime(end.year, end.month, end.day, 23, 59, 59);

    if (now.isAfter(endOfDay)) {
      // 종료일 하루의 끝을 지난 시점 → 마감
      return SurveyStatus.closed;
    } else {
      // 그 전까지는 모두 진행중
      return SurveyStatus.ongoing;
    }
  }
}
