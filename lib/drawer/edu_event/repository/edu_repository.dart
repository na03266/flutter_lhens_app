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


part 'edu_repository.g.dart';

final eduRepositoryProvider = Provider<EduRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return EduRepository(dio, baseUrl: '$ip/board-edu');
});

@RestApi()
abstract class EduRepository
    implements IBasePagePaginationRepository<PostModel> {
  factory EduRepository(Dio dio, {String baseUrl}) = _EduRepository;

  @override
  @GET('')
  @Headers({'accessToken': 'true'})
  Future<PagePagination<PostModel>> paginate({
    @Queries()
    PagePaginationParams? paginationParams = const PagePaginationParams(),
  });

  @GET('/{wrId}')
  @Headers({'accessToken': 'true'})
  Future<PostDetailModel> getEduDetail({
    @Path('wrId') required String wrId,
  });
}
