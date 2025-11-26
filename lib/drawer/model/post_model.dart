import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_model.g.dart';

@JsonSerializable()
class PostModel {
  final int wrId;
  final String wrSubject;
  final String wrName;
  final String wrDatetime;
  final String caName;
  final List<String> wrOption;
  final String wr1;
  final String wr2;
  final String wr3;
  final String wr4;
  final String wr5;

  PostModel({
    required this.wrId,
    required this.wrSubject,
    required this.wrName,
    required this.wrDatetime,
    required this.caName,
    required this.wrOption,
    required this.wr1,
    required this.wr2,
    required this.wr3,
    required this.wr4,
    required this.wr5,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);
}
