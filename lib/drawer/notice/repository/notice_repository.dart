import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lhens_app/common/const/data.dart';
import 'package:lhens_app/common/dio/dio.dart';
import 'package:lhens_app/common/model/page_pagination_model.dart';
import 'package:lhens_app/common/model/page_pagination_params.dart';
import 'package:lhens_app/common/repository/base_pagination_repository.dart';
import 'package:lhens_app/drawer/model/post_detail_model.dart';
import 'package:lhens_app/drawer/model/post_model.dart';
import 'package:retrofit/retrofit.dart';


part 'notice_repository.g.dart';

final noticeRepositoryProvider = Provider<NoticeRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return NoticeRepository(dio, baseUrl: '$ip/board-notice');
});

@RestApi()
abstract class NoticeRepository
    implements IBasePagePaginationRepository<PostModel> {
  factory NoticeRepository(Dio dio, {String baseUrl}) = _NoticeRepository;

  @override
  @GET('')
  @Headers({'accessToken': 'true'})
  Future<PagePagination<PostModel>> paginate({
    @Queries()
    PagePaginationParams? paginationParams = const PagePaginationParams(),
  });

  @GET('/{wrId}')
  @Headers({'accessToken': 'true'})
  Future<PostDetailModel> getNoticeDetail({
    @Path('wrId') required String wrId,
  });
}
