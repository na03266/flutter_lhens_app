// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  mbNo: (json['mbNo'] as num).toInt(),
  mbId: json['mbId'] as String,
  mbName: json['mbName'] as String,
  mbNick: json['mbNick'] as String,
  deptSite: json['deptSite'] == null
      ? null
      : DeptModel.fromJson(json['deptSite'] as Map<String, dynamic>),
  jobDuty: json['jobDuty'] as String? ?? '',
  mb2: json['mb2'] as String? ?? '',
  mb3: json['mb3'] as String? ?? '',
  mb5: json['mb5'] as String? ?? '',
  mbHp: json['mbHp'] as String? ?? '',
  mbEmail: json['mbEmail'] as String? ?? '',
  mbDepart: json['mbDepart'] as String? ?? '',
  registerNum: json['registerNum'] as String? ?? '',
  mbLevel: (json['mbLevel'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'mbNo': instance.mbNo,
  'mbId': instance.mbId,
  'mbName': instance.mbName,
  'mbNick': instance.mbNick,
  'jobDuty': instance.jobDuty,
  'mb2': instance.mb2,
  'mb3': instance.mb3,
  'mb5': instance.mb5,
  'mbHp': instance.mbHp,
  'mbEmail': instance.mbEmail,
  'deptSite': instance.deptSite,
  'mbDepart': instance.mbDepart,
  'registerNum': instance.registerNum,
  'mbLevel': instance.mbLevel,
};

DeptModel _$DeptModelFromJson(Map<String, dynamic> json) => DeptModel(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  parent: json['parent'] == null
      ? null
      : DeptModel.fromJson(json['parent'] as Map<String, dynamic>),
);

Map<String, dynamic> _$DeptModelToJson(DeptModel instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'parent': instance.parent,
};
