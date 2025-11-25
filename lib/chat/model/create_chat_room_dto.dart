import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_chat_room_dto.g.dart';

@JsonSerializable()
class CreateChatRoomDto {
  final String name;
  final List<int> mbNos;

  CreateChatRoomDto({required this.name, required this.mbNos});
}
