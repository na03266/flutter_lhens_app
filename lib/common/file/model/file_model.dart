import 'package:freezed_annotation/freezed_annotation.dart';

part 'file_model.g.dart';

@JsonSerializable()
class FileModel {
  final int bfNo;
  final String url;
  final String fileName;
  final String savedName;

  FileModel({
    required this.url,
    required this.fileName,
    required this.bfNo,
    required this.savedName,
  });

  factory FileModel.fromJson(Map<String, dynamic> json) =>
      _$FileModelFromJson(json);
}
