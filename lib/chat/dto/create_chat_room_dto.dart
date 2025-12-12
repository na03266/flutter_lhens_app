import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_chat_room_dto.g.dart';

@JsonSerializable(includeIfNull: false,)
class CreateChatRoomDto {
  final List<int>? memberNos;
  final List<int>? teamNos;
  final String name;

  CreateChatRoomDto({required this.name, this.teamNos, this.memberNos});

  CreateChatRoomDto copyWith({
    List<int>? memberNos,
    List<int>? teamNos,
    String? name,
  }) {
    return CreateChatRoomDto(
      name: name ?? this.name,
      memberNos: memberNos ?? this.memberNos,
      teamNos: teamNos ?? this.teamNos,
    );
  }

  factory CreateChatRoomDto.fromJson(Map<String, dynamic> json) =>
      _$CreateChatRoomDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CreateChatRoomDtoToJson(this);
}
