import 'package:lhens_app/drawer/survey/model/survey_model.dart';
import 'package:lhens_app/mock/survey/mock_survey_models.dart';

bool getSurveyStatus(SurveyModel model) {
  final now = DateTime.now();

  // 종료일 문자열을 DateTime 으로 변환
  final end = DateTime.parse(model.poDateEnd);

  // 종료일 하루의 끝(23:59:59)까지를 "진행"으로 보고 싶다면
  final endOfDay = DateTime(end.year, end.month, end.day, 23, 59, 59);

  if (now.isAfter(endOfDay)) {
    // 종료일 하루의 끝을 지난 시점 → 마감
    return false;
  } else {
    // 그 전까지는 모두 진행중
    return true;
  }
}
