
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lhens_app/common/const/data.dart';
import 'package:retrofit/retrofit.dart';

import '../../../common/dio/dio.dart';
import '../model/notice_model.dart';

part 'board_repository.g.dart';

final boardRepositoryProvider = Provider<BoardRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return BoardRepository(
    dio,
    baseUrl: ip,
  );
});

@RestApi()
abstract class BoardRepository {
  factory BoardRepository(Dio dio, {String baseUrl}) =
  _BoardRepository;

  @GET('/board/notice')
  Future<List<NoticeModel>> getNoticeList();

  // @GET('/service_info/{serviceId}')
  // Future<NoticeModel?> getNoticeDetail({
  //   @Path('serviceId') required int serviceId,
  // });
  //
  // @POST('/service_info')
  // Future<HttpResponse<dynamic>> addNotice({
  //   @Body() required NoticeAddModel model,
  // });
  //
  // @PUT('/service_info')
  // Future<HttpResponse<dynamic>> updateNotice({
  //   @Body() required NoticeAddModel model,
  // });
  //
  // @DELETE('/service_info')
  // Future<HttpResponse<dynamic>> deleteNotice(
  //     @Body() Map<String, dynamic> data);
}