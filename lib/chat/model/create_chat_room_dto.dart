import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_chat_room_dto.g.dart';

@JsonSerializable()
class CreateChatRoomDto {
  final List<int> memberNos;
  final String name;

  CreateChatRoomDto({required this.name, required this.memberNos});

  CreateChatRoomDto copyWith({List<int>? memberNos, String? name}) {
    return CreateChatRoomDto(
      name: name ?? this.name,
      memberNos: memberNos ?? this.memberNos,
    );
  }

  factory CreateChatRoomDto.fromJson(Map<String, dynamic> json) =>
      _$CreateChatRoomDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CreateChatRoomDtoToJson(this);

}
