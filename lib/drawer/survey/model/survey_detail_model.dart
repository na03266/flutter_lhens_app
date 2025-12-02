import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lhens_app/drawer/survey/model/survey_model.dart';
import 'package:lhens_app/drawer/survey/model/survey_question_model.dart';

part 'survey_detail_model.g.dart';

@JsonSerializable()
class SurveyDetailModel extends SurveyModel {
  final String poContent;
  final List<SurveyQuestionModel> questions;

  SurveyDetailModel({
    required super.poId,
    required super.poSubject,
    required super.poDate,
    required super.poDateEnd,
    required super.poCount,
    required super.isSurvey,
    required this.poContent,
    required this.questions,
  });

  factory SurveyDetailModel.fromJson(Map<String, dynamic> json) =>
      _$SurveyDetailModelFromJson(json);
}
