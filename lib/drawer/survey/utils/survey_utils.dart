import '../model/survey_model.dart';

bool getSurveyStatus(SurveyModel model) {
  final now = DateTime.now();
  final endStr = model.poDateEnd;

  // 1) 마감일 없음(1899-11-30) 처리
  //    - 서버 포맷에 맞춰서 조건을 추가하세요.
  if (endStr == '1899-11-30' || endStr == '18991130') {
    // "마감일 없음" → 항상 진행중으로 판단
    return true;
  }

  // 2) 혹시라도 이상한 값이 들어왔을 때를 대비한 안전 처리
  DateTime end;
  try {
    end = DateTime.parse(endStr); // "2025-12-01" 형식
  } catch (_) {
    // 파싱 실패 시, 보수적으로 "진행 중"으로 처리
    return true;
  }

  // 종료일 하루의 끝(23:59:59)까지 진행으로 보고 싶다면:
  final endOfDay = DateTime(end.year, end.month, end.day, 23, 59, 59);

  // endOfDay 이후면 마감, 그 전이면 진행중
  return !now.isAfter(endOfDay);
}
