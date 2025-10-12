import 'dart:math';
import 'package:lhens_app/mock/survey/mock_survey_models.dart';

List<SurveyItem> generateSurveyItems(int n) {
  final rng = Random(2025);

  String pad2(int v) => v.toString().padLeft(2, '0');

  return List<SurveyItem>.generate(n, (i) {
    final isOngoing = i % 3 != 2; // 약 2/3 진행중
    final isRealname = i % 2 == 0; // 절반 실명
    final day = (i % 28) + 1;
    final start = '2025. 01. ${pad2(day)}';
    final end = '2025. 01. ${pad2(((day + 1) % 28) + 1)}';
    final participated = rng.nextBool() && isOngoing;

    return SurveyItem(
      status: isOngoing ? SurveyStatus.ongoing : SurveyStatus.closed,
      nameType: isRealname ? SurveyNameType.realname : SurveyNameType.anonymous,
      title: '설문조사 제목이 표시되는 영역입니다. 설문조사 제목이 표시되는 영역입니다.',
      dateRangeText: '$start ~ $end',
      target: '경남지역본부',
      author: 'LH E&S',
      participated: participated,
    );
  });
}
