import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lhens_app/common/components/report/report_list_scaffold_v2.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/drawer/survey/component/survey_list_item.dart';
import 'package:lhens_app/drawer/survey/model/survey_model.dart';
import 'package:lhens_app/drawer/survey/provider/survey_provider.dart';
import 'package:lhens_app/drawer/survey/utils/survey_utils.dart';
import 'package:lhens_app/drawer/survey/view/survey_detail_screen.dart';

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
        mineOnly: widget.mineOnly,
        tabs: ['진행', '마감'],
        filters: ['전체'],
        selectTabName: (String selectedTab) {
          setState(() {
            caName = selectedTab.replaceAll(" ", "");
          });
          ref
              .read(surveyProvider.notifier)
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
              .read(surveyProvider.notifier)
              .paginate(fetchPage: 1, caName: caName, wr1: wr1, title: title);
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
              isProcessing: getSurveyStatus(model),
              title: model.poSubject,
              dateRangeText: model.poDateEnd.startsWith('1899')
                  ? '기한 없음'
                  : '${model.poDate} ~ ${model.poDateEnd}',
              author: model.poCount.toString(),
              participated: model.isSurvey,
            ),
          );
        },
      ),
    );
  }
}
