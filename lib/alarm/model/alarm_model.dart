import 'package:freezed_annotation/freezed_annotation.dart';

part 'alarm_model.g.dart';

abstract class AlarmModelBase {}

class AlarmModelLoading extends AlarmModelBase {}

class AlarmModelError extends AlarmModelBase {
  final String message;

  AlarmModelError({required this.message});
}

@JsonSerializable()
class AlarmModel extends AlarmModelBase {
  final List<AlarmItemModel> data;
  final int count;

  AlarmModel({required this.data, required this.count});

  factory AlarmModel.fromJson(Map<String, dynamic> json) =>
      _$AlarmModelFromJson(json);

  AlarmModel copyWith({List<AlarmItemModel>? data, int? count}) {
    return AlarmModel(data: data ?? this.data, count: count ?? this.count);
  }
}

@JsonSerializable()
class AlarmItemModel {
  final String id;
  final int mbNo;
  final String title;
  final String body;
  final AlarmDataModel? data;
  final String sentAt;
  final bool isRead;

  AlarmItemModel({
    required this.id,
    required this.mbNo,
    required this.title,
    required this.body,
    this.data,
    required this.sentAt,
    required this.isRead,
  });

  factory AlarmItemModel.fromJson(Map<String, dynamic> json) =>
      _$AlarmItemModelFromJson(json);

  AlarmItemModel copyWith({
    String? id,
    int? mbNo,
    String? title,
    String? body,
    AlarmDataModel? data,
    String? sentAt,
    bool? isRead,
  }) {
    return AlarmItemModel(
      id: id ?? this.id,
      mbNo: mbNo ?? this.mbNo,
      title: title ?? this.title,
      body: body ?? this.body,
      data: data ?? this.data,
      sentAt: sentAt ?? this.sentAt,
      isRead: isRead ?? this.isRead,
    );
  }
}

@JsonSerializable()
class AlarmDataModel {
  final String? wrId;

  AlarmDataModel({this.wrId});

  factory AlarmDataModel.fromJson(Map<String, dynamic> json) =>
      _$AlarmDataModelFromJson(json);
}
