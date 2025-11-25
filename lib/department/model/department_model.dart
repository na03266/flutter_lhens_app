import 'package:freezed_annotation/freezed_annotation.dart';

part 'department_model.g.dart';

abstract class DepartmentModelBase {}

class DepartmentModelLoading extends DepartmentModelBase {}

class DepartmentModelError extends DepartmentModelBase {
  final String message;

  DepartmentModelError({required this.message});
}

@JsonSerializable()
class DepartmentModelList extends DepartmentModelBase {
  final List<DepartmentModel> data;

  DepartmentModelList({required this.data});

  factory DepartmentModelList.fromJson(Map<String, dynamic> json) =>
      _$DepartmentModelListFromJson(json);

  DepartmentModelList copyWith({List<DepartmentModel>? data}) {
    return DepartmentModelList(data: data ?? this.data);
  }
}

@JsonSerializable()
class DepartmentModel {
  final int id;
  final String name;
  final bool isMb;
  final List<DepartmentModel> children;

  DepartmentModel({
    required this.id,
    required this.name,
    this.isMb = false,
    this.children = const [],
  });

  factory DepartmentModel.fromJson(Map<String, dynamic> json) =>
      _$DepartmentModelFromJson(json);

  DepartmentModel copyWith({
    int? id,
    String? name,
    bool? isMb,
    List<DepartmentModel>? children,
  }) {
    return DepartmentModel(
      id: id ?? this.id,
      name: name ?? this.name,
      isMb: isMb ?? this.isMb,
      children: children ?? this.children,
    );
  }
}
