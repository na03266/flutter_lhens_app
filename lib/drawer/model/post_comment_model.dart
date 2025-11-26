import 'package:freezed_annotation/freezed_annotation.dart';

import 'post_model.dart';

part 'post_comment_model.g.dart';

@JsonSerializable()
class PostCommentModel extends PostModel {
  final String wrContent;
  final int wrHit;
  final int wrComment;
  final String wrCommentReply;

  PostCommentModel({
    required super.wrId,
    required super.wrSubject,
    required super.wrName,
    required super.wrDatetime,
    required super.caName,
    required super.wrOption,
    required super.wr1,
    required super.wr2,
    required super.wr3,
    required super.wr4,
    required super.wr5,
    required this.wrContent,
    required this.wrHit,
    required this.wrCommentReply,
    required this.wrComment,
  });

  factory PostCommentModel.fromJson(Map<String, dynamic> json) =>
      _$PostCommentModelFromJson(json);
}
