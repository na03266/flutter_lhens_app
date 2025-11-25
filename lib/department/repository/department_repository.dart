import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lhens_app/common/const/data.dart';
import 'package:lhens_app/department/model/department_detail_model.dart';
import 'package:lhens_app/department/model/department_model.dart';
import 'package:retrofit/retrofit.dart';

import '../../common/dio/dio.dart';

part 'department_repository.g.dart';

final departmentRepositoryProvider = Provider<DepartmentRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return DepartmentRepository(dio, baseUrl: '$ip/department');
});

@RestApi()
abstract class DepartmentRepository {
  factory DepartmentRepository(Dio dio, {String baseUrl}) =
      _DepartmentRepository;

  @GET('/')
  @Headers({'accessToken': 'true'})
  Future<DepartmentModelList> getDepartments();

  @GET('/{id}')
  @Headers({'accessToken': 'true'})
  Future<DepartmentDetailModel> getMembers({@Path('id') required int id});
}
