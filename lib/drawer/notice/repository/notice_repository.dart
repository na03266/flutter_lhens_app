import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lhens_app/common/const/data.dart';
import 'package:lhens_app/common/dio/dio.dart';
import 'package:lhens_app/common/model/page_pagination_model.dart';
import 'package:lhens_app/common/model/page_pagination_params.dart';
import 'package:lhens_app/common/repository/base_pagination_repository.dart';
import 'package:lhens_app/drawer/notice/model/notice_model.dart';
import 'package:retrofit/retrofit.dart';

import '../model/notice_detail_model.dart';

part 'notice_repository.g.dart';

final noticeRepositoryProvider = Provider<NoticeRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return NoticeRepository(dio, baseUrl: '$ip/board-notice');
});

@RestApi()
abstract class NoticeRepository
    implements IBasePagePaginationRepository<NoticeModel> {
  factory NoticeRepository(Dio dio, {String baseUrl}) = _NoticeRepository;

  @override
  @GET('')
  @Headers({'accessToken': 'true'})
  Future<PagePagination<NoticeModel>> paginate({
    @Queries()
    PagePaginationParams? paginationParams = const PagePaginationParams(),
  });

  @GET('/{id}')
  Future<NoticeDetailModel> getNoticeDetail({
    @Path('wrId') required String wrId,
  });
}
