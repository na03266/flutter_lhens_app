import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_model.g.dart';

enum MessageType { SYSTEM, TEXT, FILE, IMAGE }
// 숫자 → enum
MessageType _messageTypeFromJson(int code) {
  // 안전하게 범위 체크
  if (code < 0 || code >= MessageType.values.length) {
    return MessageType.TEXT; // 기본값 하나 정해두기
  }
  return MessageType.values[code];
}

// enum → 숫자
int _messageTypeToJson(MessageType type) => type.index;

@JsonSerializable()
class MessageModel {
  final String id;
  final int authorNo;
  final String senderName;
  final String content;
  final String createdAt;
  final bool isMine;
  final String filePath;

  @JsonKey(fromJson: _messageTypeFromJson, toJson: _messageTypeToJson)
  final MessageType type;

  MessageModel({
     required this.id,
     required this.authorNo,
     required this.senderName,
     required this.content,
     required this.createdAt,
     required this.isMine,
     required this.filePath,
     required this.type,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);
}
