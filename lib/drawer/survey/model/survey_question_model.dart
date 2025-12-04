import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lhens_app/drawer/survey/model/survey_option_model.dart';

part 'survey_question_model.g.dart';

enum SQType { radio, checkbox, radio_text , text }

@JsonSerializable()
class SurveyQuestionModel  {
  final int sqId;
  final int poId;
  final int sqOrder;
  final String sqTitle;
  final SQType sqType;
  final int sqRequired;
  final List<SurveyOptionModel> options;

  SurveyQuestionModel({
    required this.sqId,
    required this.poId,
    required this.sqOrder,
    required this.sqTitle,
    required this.sqType,
    required this.sqRequired,
    required this.options,
  });

  factory SurveyQuestionModel.fromJson(Map<String, dynamic> json) =>
      _$SurveyQuestionModelFromJson(json);
}
