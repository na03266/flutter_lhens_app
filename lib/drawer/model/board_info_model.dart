import 'package:freezed_annotation/freezed_annotation.dart';

part 'board_info_model.g.dart';

abstract class BoardInfoBase {}

class BoardInfoLoading extends BoardInfoBase {}

class BoardInfoError extends BoardInfoBase {
  final String message;

  BoardInfoError({required this.message});
}

@JsonSerializable()
class BoardInfo extends BoardInfoBase {
  final String boTable;
  final String boSubject;
  final String boCategoryList;
  final String total;

  BoardInfo({
    required this.boTable,
    required this.boSubject,
    required this.boCategoryList,
    required this.total,
  });

  factory BoardInfo.fromJson(Map<String, dynamic> json) =>
      _$BoardInfoFromJson(json);
}
