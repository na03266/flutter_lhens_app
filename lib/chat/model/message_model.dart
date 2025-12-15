import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lhens_app/user/model/user_model.dart';

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
  final UserModel? author;
  final String content;
  final String createdAt;
  final String filePath;
  @JsonKey(fromJson: _messageTypeFromJson, toJson: _messageTypeToJson)
  final MessageType type;
  final String? tempId;
  final int? unreadMembers;


  MessageModel({
    required this.id,
    this.author,
    required this.content,
    required this.createdAt,
    this.filePath = '',
    required this.type,
    this.tempId,
    this.unreadMembers,
  });

  MessageModel copyWith({
    String? id,
    UserModel? author,
    String? content,
    String? createdAt,
    bool? isMine,
    String? filePath,
    MessageType? type,
    int? unreadMembers,
  }) {
    return MessageModel(
      id: id ?? this.id,
      author: author ?? this.author,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      filePath: filePath ?? this.filePath,
      type: type ?? this.type,
      unreadMembers: unreadMembers ?? this.unreadMembers,
    );
  }

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);
}
