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
  final int mbNo;
  final String mbId;
  final String mbName;
  final String mbNick;
  final String jobDuty;
  final String mb2; // 직위
  final String mb3; // 입사일
  final String mb5; // 직무
  final String mbHp;
  final String mbEmail;
  final DeptModel? deptSite;
  final String mbDepart; // 소속
  final String registerNum;
  final int mbLevel;

  UserModel({
    required this.mbNo,
    required this.mbId,
    required this.mbName,
    required this.mbNick,
    this.deptSite,
    this.jobDuty = '',
    this.mb2 = '',
    this.mb3 = '',
    this.mb5 = '',
    this.mbHp = '',
    this.mbEmail = '',
    this.mbDepart = '',
    this.registerNum = '',
    this.mbLevel = 0,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

@JsonSerializable()
class DeptModel {
  final int id;
  final String name;
  final DeptModel? parent ;

  DeptModel({
    required this.id,
    required this.name,
    this.parent,
  });

  factory DeptModel.fromJson(Map<String, dynamic> json) =>
      _$DeptModelFromJson(json);
}