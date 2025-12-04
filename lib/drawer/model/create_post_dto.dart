import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_post_dto.g.dart';

@JsonSerializable(includeIfNull: false)
class CreatePostDto {
  final String? wrSubject;
  final String wrContent;
  final String? caName;
  final String? wrOption;
  final String? wrLink1;
  final String? wrLink2;
  final String? wr1;
  final String? wr2;

  CreatePostDto({
      this.wrSubject,
    required this.wrContent,
    this.caName,
    this.wrOption,
    this.wrLink1,
    this.wrLink2,
    this.wr1,
    this.wr2,
  });

  CreatePostDto copyWith({
    String? wrSubject,
    String? wrContent,
    String? caName,
    String? wrOption,
    String? wrLink1,
    String? wrLink2,
    String? wr1,
    String? wr2,
  }) {
    return CreatePostDto(
      wrSubject: wrSubject ?? this.wrSubject,
      wrContent: wrContent ?? this.wrContent,
      caName: caName ?? this.caName,
      wrOption: wrOption ?? this.wrOption,
      wrLink1: wrLink1 ?? this.wrLink1,
      wrLink2: wrLink2 ?? this.wrLink2,
      wr1: wr1 ?? this.wr1,
      wr2: wr2 ?? this.wr2,
    );
  }

  factory CreatePostDto.fromJson(Map<String, dynamic> json) =>
      _$CreatePostDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CreatePostDtoToJson(this);
}
