import 'package:freezed_annotation/freezed_annotation.dart';

part 'salary_model.g.dart';

abstract class SalaryModelBase {}

class SalaryModelLoading extends SalaryModelBase {}

class SalaryModelError extends SalaryModelBase {
  final String message;

  SalaryModelError({required this.message});
}

@JsonSerializable()
class SalaryModel extends SalaryModelBase {
  final List<int> years;
  final List<SalaryDetailModel> data;

  SalaryModel({required this.years, required this.data});

  factory SalaryModel.fromJson(Map<String, dynamic> json) =>
      _$SalaryModelFromJson(json);
}

@JsonSerializable()
class SalaryDetailModel {
  final int year;
  final int month;
  final int saId;

  SalaryDetailModel({
    required this.year,
    required this.month,
    required this.saId,
  });

  factory SalaryDetailModel.fromJson(Map<String, dynamic> json) =>
      _$SalaryDetailModelFromJson(json);
}
