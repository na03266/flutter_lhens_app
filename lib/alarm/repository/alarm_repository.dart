import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lhens_app/alarm/model/alarm_model.dart';
import 'package:lhens_app/common/const/data.dart';
import 'package:retrofit/retrofit.dart';

import '../../common/dio/dio.dart';

part 'alarm_repository.g.dart';

final alarmRepositoryProvider = Provider<AlarmRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return AlarmRepository(dio, baseUrl: '$ip/notification');
});

@RestApi()
abstract class AlarmRepository {
  factory AlarmRepository(Dio dio, {String baseUrl}) = _AlarmRepository;

  @GET('')
  @Headers({'accessToken': 'true'})
  Future<AlarmModel> getItems({@Query('isRead') int? isRead});

  @PATCH('/{id}')
  @Headers({'accessToken': 'true', 'Content-Type': 'application/json'})
  Future<void> markAsRead({@Path('id') required String id});
}
