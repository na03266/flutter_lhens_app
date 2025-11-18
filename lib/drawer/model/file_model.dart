import 'package:freezed_annotation/freezed_annotation.dart';

part 'file_model.g.dart';

@JsonSerializable()
class FileModel {
  final String url;
  final String fileName;

  FileModel({required this.url, required this.fileName});

  factory FileModel.fromJson(Map<String, dynamic> json) =>
      _$FileModelFromJson(json);
}
