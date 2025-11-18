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
  final List<BoardInfoItem> items;
  BoardInfo({
    required this.items,
  });

  factory BoardInfo.fromJson(Map<String, dynamic> json) =>
      _$BoardInfoFromJson(json);
}

@JsonSerializable()
class BoardInfoItem extends BoardInfoBase {
  final String boTable;
  final String boSubject;
  final String boCategoryList;
  final String bo1;

  BoardInfoItem({
    required this.boTable,
    required this.boSubject,
    required this.boCategoryList,
    required this.bo1,
  });

  factory BoardInfoItem.fromJson(Map<String, dynamic> json) =>
      _$BoardInfoItemFromJson(json);
}
