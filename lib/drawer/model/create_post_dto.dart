import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_post_dto.g.dart';

@JsonSerializable(includeIfNull: false)
class CreatePostDto {
  final String wrSubject;
  final String wrContent;
  final String? caName;
  final String? wrOption;     // 'html1,secret,mail'
  final String? wrLink1;
  final String? wrLink2;
  final String? wr1;
  final String? wr2;

  CreatePostDto({
    required this.wrSubject,
    required this.wrContent,
    this.caName,
    this.wrOption,
    this.wrLink1,
    this.wrLink2,
    this.wr1,
    this.wr2,
  });

  factory CreatePostDto.fromJson(Map<String, dynamic> json) =>
      _$CreatePostDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CreatePostDtoToJson(this);
}