import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:lhens_app/common/components/report/report_list_scaffold.dart';
import 'package:lhens_app/common/components/report/report_list_config.dart';
import 'package:lhens_app/drawer/survey/component/survey_list_item.dart';
import 'package:lhens_app/gen/assets.gen.dart';
import 'package:lhens_app/mock/survey/mock_survey_models.dart';
import 'package:lhens_app/mock/survey/mock_survey_data.dart';

class SurveyScreen extends ConsumerWidget {
  static String get routeName => '설문조사';
  final bool mineOnly;

  const SurveyScreen({super.key, this.mineOnly = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ReportListConfig<SurveyItem>(
      tabs: const ['전체', '진행', '마감'],
      filters: const ['전체', '작성자', '대상'],
      emptyMessage: (tab, {required bool mineOnly}) {
        if (mineOnly) return '참여한 설문이 없습니다.';
        return switch (tab) {
          2 => '마감된 설문이 없습니다.',
          1 => '진행중인 설문이 없습니다.',
          _ => '등록된 설문이 없습니다.',
        };
      },
      emptyIconPath: Assets.icons.features.surveyDoc.path,
      showFab: false,
      detailRouteName: '설문 상세',
      myDetailRouteName: '내 설문 상세',
      formRouteName: '설문 작성',

      load: () async => generateSurveyItems(10),

      tabPredicate: (e, tab) => switch (tab) {
        1 => e.status == SurveyStatus.ongoing,
        2 => e.status == SurveyStatus.closed,
        _ => true,
      },

      searchPredicate: (e, f, q) {
        if (q.isEmpty) return true;
        final title = e.title.toLowerCase();
        final author = e.author.toLowerCase();
        final target = e.target.toLowerCase();
        return switch (f) {
          '작성자' => author.contains(q),
          '대상' => target.contains(q),
          _ => title.contains(q) || author.contains(q) || target.contains(q),
        };
      },
      mineOnlyPredicate: (e) => e.participated,

      itemBuilder: (ctx, item) => SurveyListItem(
        status: item.status,
        nameType: item.nameType,
        title: item.title,
        dateRangeText: item.dateRangeText,
        target: item.target,
        author: item.author,
        participated: item.participated,
        onTap: () => ctx.pushNamed('설문 상세'),
      ),
    );

    return ReportListScaffold<SurveyItem>(config: config, mineOnly: mineOnly);
  }
}
