import 'package:freezed_annotation/freezed_annotation.dart';

part 'room_cursor_model.g.dart';

@JsonSerializable()
class RoomCursor {
  final int mbNo;
  final String? lastReadId; // 메시지 id 타입에 따라 String이면 String으로

  RoomCursor({required this.mbNo, this.lastReadId});

  RoomCursor copyWith({int? mbNo, String? lastReadId}) {
    return RoomCursor(
      mbNo: mbNo ?? this.mbNo,
      lastReadId: lastReadId ?? this.lastReadId,
    );
  }

  factory RoomCursor.fromJson(Map<String, dynamic> json) =>
      _$RoomCursorFromJson(json);
}
