// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  mbId: json['mbId'] as String,
  mbName: json['mbName'] as String,
  mbNick: json['mbNick'] as String,
  jobDuty: json['jobDuty'] as String? ?? '',
  mb2: json['mb2'] as String? ?? '',
  mb3: json['mb3'] as String? ?? '',
  mbHp: json['mbHp'] as String? ?? '',
  mbEmail: json['mbEmail'] as String? ?? '',
  mbDepart: json['mbDepart'] as String? ?? '',
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'mbId': instance.mbId,
  'mbName': instance.mbName,
  'mbNick': instance.mbNick,
  'jobDuty': instance.jobDuty,
  'mb2': instance.mb2,
  'mb3': instance.mb3,
  'mbHp': instance.mbHp,
  'mbEmail': instance.mbEmail,
  'mbDepart': instance.mbDepart,
};
