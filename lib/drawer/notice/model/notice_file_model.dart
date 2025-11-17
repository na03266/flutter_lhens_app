import 'package:freezed_annotation/freezed_annotation.dart';

part 'notice_file_model.g.dart';

@JsonSerializable()
class NoticeFileModel {
  final String url;
  final String fileName;

  NoticeFileModel({required this.url, required this.fileName});

  factory NoticeFileModel.fromJson(Map<String, dynamic> json) =>
      _$NoticeFileModelFromJson(json);
}
