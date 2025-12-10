import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_member_model.g.dart';

@JsonSerializable()
class ChatMember {
  final int mbNo;
  final String name;
  final String department;
  final String registerNum;
  final String mb5;
  final String mb2;

  ChatMember({
    required this.mbNo,
    required this.name,
    required this.department,
    required this.registerNum,
    required this.mb5,
    required this.mb2,
  });

  factory ChatMember.fromJson(Map<String, dynamic> json) =>
      _$ChatMemberFromJson(json);


}
