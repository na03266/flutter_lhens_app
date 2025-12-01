import 'package:freezed_annotation/freezed_annotation.dart';

part 'survey_model.g.dart';

@JsonSerializable()
class SurveyModel {
  final int poId;
  final String poSubject;
  final String poDate;
  final String poDateEnd;
  final int poCnt1; //참여자수
  final bool isSurvey;

  SurveyModel({
    required this.poId,
    required this.poSubject,
    required this.poDate,
    required this.poDateEnd,
    required this.poCnt1,
    required this.isSurvey,
  });

  factory SurveyModel.fromJson(Map<String, dynamic> json) =>
      _$SurveyModelFromJson(json);
}
