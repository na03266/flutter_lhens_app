import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_login_model.g.dart';

abstract class UserLoginModelBase {}

class UserLoginModelLoading extends UserLoginModelBase {}

class UserLoginModelError extends UserLoginModelBase {
  final String message;

  UserLoginModelError({required this.message});
}

@JsonSerializable()
class UserLoginModel extends UserLoginModelBase {
  final String mbId;
  final String mbPassword;

  UserLoginModel({
    required this.mbId,
    required this.mbPassword,
  });

  factory UserLoginModel.fromJson(Map<String, dynamic> json) =>
      _$UserLoginModelFromJson(json);
}
