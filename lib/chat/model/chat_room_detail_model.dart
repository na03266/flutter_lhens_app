import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lhens_app/chat/model/chat_member_model.dart';
import 'package:lhens_app/chat/model/chat_room_model.dart';

part 'chat_room_detail_model.g.dart';

@JsonSerializable()
class ChatRoomDetail extends ChatRoom {
  final List<ChatMember> members;

  ChatRoomDetail({
    required super.roomId,
    required super.name,
    required super.memberCount,
    required super.newMessageCount,
    required this.members,
  });

  factory ChatRoomDetail.fromJson(Map<String, dynamic> json) =>
      _$ChatRoomDetailFromJson(json);
}
