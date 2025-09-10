import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.g.dart';

abstract class UserModelBase {}

class UserModelLoading extends UserModelBase {}

class UserModelError extends UserModelBase {
  final String message;

  UserModelError({required this.message});
}

@JsonSerializable()
class UserModel extends UserModelBase {
  final String mbId;
  final String mbName;

  UserModel({
    required this.mbId,
    required this.mbName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
