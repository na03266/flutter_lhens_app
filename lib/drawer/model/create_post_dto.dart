import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lhens_app/common/file/model/temp_file_model.dart';

part 'create_post_dto.g.dart';

@JsonSerializable(includeIfNull: false,explicitToJson: true)
class CreatePostDto {
  final String? wrSubject;
  final String wrContent;
  final String? caName;
  final String? wrOption;
  final String? wrLink1;
  final String? wrLink2;
  final String? wr1;
  final String? wr2;
  final String? wr3;
  final String? wr4;
  final String? wr5;
  final List<TempFileModel>? files;
  final List<int>? keepFiles;
  final List<TempFileModel>? newFiles;

  CreatePostDto({
      this.wrSubject,
    required this.wrContent,
    this.caName,
    this.wrOption,
    this.wrLink1,
    this.wrLink2,
    this.wr1,
    this.wr2,
    this.wr3,
    this.wr4,
    this.wr5,
    this.files,
    this.keepFiles,
    this.newFiles,
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
    String? wr3,
    String? wr4,
    String? wr5,
    List<TempFileModel>? files,
    List<int>? keepFiles,
    List<TempFileModel>? newFiles,
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
      wr5: wr5 ?? this.wr5,
      files: files ?? this.files,
      keepFiles: keepFiles ?? this.keepFiles,
      newFiles: newFiles ?? this.newFiles,
    );
  }

  factory CreatePostDto.fromJson(Map<String, dynamic> json) =>
      _$CreatePostDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CreatePostDtoToJson(this);
}
