import 'package:freezed_annotation/freezed_annotation.dart';

part 'temp_file_model.g.dart';

@JsonSerializable()
class TempFileModel {
  final String originalName;
  final String savedName;

  TempFileModel({
    required this.originalName,
    required this.savedName,
  });

  factory TempFileModel.fromJson(Map<String, dynamic> json) =>
      _$TempFileModelFromJson(json);

  Map<String, dynamic> toJson() => _$TempFileModelToJson(this);
}
