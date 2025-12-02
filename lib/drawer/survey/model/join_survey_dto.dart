import 'package:freezed_annotation/freezed_annotation.dart';

part 'join_survey_dto.g.dart';

@JsonSerializable(includeIfNull: false)
class JoinSurveyDto {
  final int sqId;
  final int? soId;
  final String? text;

  JoinSurveyDto({required this.sqId, this.soId, this.text});

  factory JoinSurveyDto.fromJson(Map<String, dynamic> json) =>
      _$JoinSurveyDtoFromJson(json);

  Map<String, dynamic> toJson() => _$JoinSurveyDtoToJson(this);
}
