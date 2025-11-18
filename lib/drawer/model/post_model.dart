import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_model.g.dart';

@JsonSerializable()
class PostModel {
  final int wrId;
  final String wrSubject;
  final String wrName;
  final String wrDatetime;
  final String caName;
  final String wr1;

  PostModel({
    required this.wrId,
    required this.wrSubject,
    required this.wrName,
    required this.wrDatetime,
    required this.caName,
    required this.wr1,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);
}
