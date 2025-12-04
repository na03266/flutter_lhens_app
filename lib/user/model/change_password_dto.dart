import 'package:freezed_annotation/freezed_annotation.dart';

part 'change_password_dto.g.dart';

@JsonSerializable()
class ChangePasswordDto {
  final String mbId;
  final String registerNum;
  final String newPassword;

  ChangePasswordDto({
    required this.mbId,
    required this.registerNum,
    required this.newPassword,
  });

  factory ChangePasswordDto.fromJson(Map<String, dynamic> json) =>
      _$ChangePasswordDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ChangePasswordDtoToJson(this);
}
