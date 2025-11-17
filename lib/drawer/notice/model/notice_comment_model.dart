import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lhens_app/drawer/notice/model/notice_model.dart';

part 'notice_comment_model.g.dart';

@JsonSerializable()
class NoticeCommentModel extends NoticeModel {
  final String wrContent;
  final int wrHit;

  NoticeCommentModel({
    required super.wrId,
    required super.wrSubject,
    required super.wrName,
    required super.wrDatetime,
    required super.caName,
    required super.wr1,
    required this.wrContent,
    required this.wrHit,
  });

  factory NoticeCommentModel.fromJson(Map<String, dynamic> json) =>
      _$NoticeCommentModelFromJson(json);
}

