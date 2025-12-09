import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lhens_app/common/file/model/file_model.dart';
import 'package:lhens_app/drawer/model/post_model.dart';

import 'post_comment_model.dart';

part 'post_detail_model.g.dart';

@JsonSerializable()
class PostDetailModel extends PostModel {
  final String wrContent;
  final int wrHit;
  final List<FileModel> files;
  final List<PostCommentModel> comments;

  PostDetailModel({
    required super.wrId,
    required super.wrSubject,
    required super.wrName,
    required super.wrDatetime,
    required super.wrComment,
    required super.caName,
    required super.wrOption,
    required super.wr1,
    required super.wr2,
    required super.wr3,
    required super.wr4,
    required super.wr5,
    required this.wrContent,
    required this.wrHit,
    required this.comments,
    required this.files,
    required super.wrLink1,
    required super.wrLink2,
  });

  factory PostDetailModel.fromJson(Map<String, dynamic> json) =>
      _$PostDetailModelFromJson(json);
}
