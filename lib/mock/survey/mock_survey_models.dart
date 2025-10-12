import 'package:flutter/foundation.dart';

enum SurveyStatus { ongoing, closed }
enum SurveyNameType { realname, anonymous }

@immutable
class SurveyItem {
  final SurveyStatus status; // 진행중/마감
  final SurveyNameType nameType; // 실명/익명
  final String title; // 설문 제목
  final String dateRangeText; // 예: '2025. 01. 15 ~ 2025. 01. 16'
  final String target; // 설문대상
  final String author; // 작성자
  final bool participated; // 참여 여부

  const SurveyItem({
    required this.status,
    required this.nameType,
    required this.title,
    required this.dateRangeText,
    required this.target,
    required this.author,
    required this.participated,
  });
}
