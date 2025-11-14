import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lhens_app/drawer/notice/model/notice_model.dart';

part 'notice_detail_model.g.dart';

@JsonSerializable()
class NoticeDetailModel extends NoticeModel {
  final String wrContent;
  final int wrHit;
  final List<NoticeAttachmentModel> attachments;

  NoticeDetailModel({
    required super.wrId,
    required super.wrSubject,
    required super.wrName,
    required super.wrDatetime,
    required super.caName,
    required super.wr1,
    required this.wrContent,
    required this.wrHit,
    required this.attachments,
  });

  factory NoticeDetailModel.fromJson(Map<String, dynamic> json) =>
      _$NoticeDetailModelFromJson(json);
}

@JsonSerializable()
class NoticeAttachmentModel {
  final String url;
  final String fileName;

  NoticeAttachmentModel({required this.url, required this.fileName});

  factory NoticeAttachmentModel.fromJson(Map<String, dynamic> json) =>
      _$NoticeAttachmentModelFromJson(json);
}
