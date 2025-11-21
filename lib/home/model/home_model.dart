import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lhens_app/drawer/model/post_model.dart';

part 'home_model.g.dart';

abstract class HomeModelBase {}

class HomeModelLoading extends HomeModelBase {}

class HomeModelError extends HomeModelBase {
  final String message;

  HomeModelError({required this.message});
}

@JsonSerializable()
class HomeModel extends HomeModelBase {
  final List<PostModel> noticeItems;

  HomeModel({required this.noticeItems});

  factory HomeModel.fromJson(Map<String, dynamic> json) =>
      _$HomeModelFromJson(json);

  HomeModel copyWith({List<PostModel>? noticeItems}) {
    return HomeModel(noticeItems: noticeItems ?? this.noticeItems);
  }
}