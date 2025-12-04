import 'package:freezed_annotation/freezed_annotation.dart';

part 'survey_option_model.g.dart';

@JsonSerializable()
class SurveyOptionModel  {
  final int soId;
  final int sqId;
  final int soOrder;
  final String soText;
  final int soHasInput; // 주관식 (선택시 객관식 여부)

  SurveyOptionModel({
    required this.soId,
    required this.sqId,
    required this.soOrder,
    required this.soText,
    required this.soHasInput,
  });

  factory SurveyOptionModel.fromJson(Map<String, dynamic> json) =>
      _$SurveyOptionModelFromJson(json);
}
