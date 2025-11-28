import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_html/flutter_html.dart';
import 'package:lhens_app/common/const/data.dart';
import 'package:lhens_app/common/dio/dio.dart';
import 'package:lhens_app/drawer/salary/model/salary_model.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'salary_repository.g.dart';

final salaryRepositoryProvider = Provider<SalaryRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return SalaryRepository(dio, baseUrl: '$ip/salary');
});

@RestApi()
abstract class SalaryRepository {
  factory SalaryRepository(Dio dio, {String baseUrl}) = _SalaryRepository;

  @GET('')
  @Headers({'accessToken': 'true'})
  Future<SalaryModel> getSalaries({@Query('year') int? year});

  @GET('/html/{id}')
  @Headers({'accessToken': 'true'})
  Future<String> getSalary({@Path('id') int? id});
}
