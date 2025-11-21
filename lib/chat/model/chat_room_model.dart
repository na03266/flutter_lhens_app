import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_room_model.g.dart';

@JsonSerializable()
class ChatRoom {
  final int roomId;
  final String name;
  final int memberCount;
  final int newMessageCount;

  ChatRoom({
    required this.roomId,
    required this.name,
    required this.memberCount,
    required this.newMessageCount,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) =>
      _$ChatRoomFromJson(json);
}
