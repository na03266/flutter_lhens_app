import 'package:freezed_annotation/freezed_annotation.dart';

part 'notice_model.g.dart';

@JsonSerializable()
class NoticeModel {
  final int wrId;
  final String wrSubject;
  final String wrName;
  final String wrDatetime;
  final String caName;
  final String wr1;

  NoticeModel({
    required this.wrId,
    required this.wrSubject,
    required this.wrName,
    required this.wrDatetime,
    required this.caName,
    required this.wr1,
  });

  factory NoticeModel.fromJson(Map<String, dynamic> json) =>
      _$NoticeModelFromJson(json);
}
