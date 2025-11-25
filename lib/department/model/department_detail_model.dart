import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lhens_app/user/model/user_model.dart';

import 'department_model.dart';

part 'department_detail_model.g.dart';

@JsonSerializable()
class DepartmentDetailModel extends DepartmentModel {
  final List<UserModel> members;
  final int? grandParentId;
  final int? parentId;

  DepartmentDetailModel({
    required super.id,
    required super.name,
    required super.isMb,
    required super.children,
    required this.members,
    required this.grandParentId,
    required this.parentId,
  });

  factory DepartmentDetailModel.fromJson(Map<String, dynamic> json) =>
      _$DepartmentDetailModelFromJson(json);
}
