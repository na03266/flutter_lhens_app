import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lhens_app/common/const/data.dart';
import 'package:lhens_app/common/dio/dio.dart';
import 'package:lhens_app/common/model/page_pagination_model.dart';
import 'package:lhens_app/common/model/page_pagination_params.dart';
import 'package:lhens_app/common/repository/base_pagination_repository.dart';
import 'package:lhens_app/drawer/model/create_post_dto.dart';
import 'package:lhens_app/drawer/model/post_detail_model.dart';
import 'package:lhens_app/drawer/model/post_model.dart';
import 'package:retrofit/retrofit.dart';

part 'risk_repository.g.dart';

final riskRepositoryProvider = Provider<RiskRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return RiskRepository(dio, baseUrl: '$ip/board-risk');
});

@RestApi()
abstract class RiskRepository
    implements IBasePagePaginationRepository<PostModel> {
  factory RiskRepository(Dio dio, {String baseUrl}) = _RiskRepository;

  @override
  @GET('')
  @Headers({'accessToken': 'true'})
  Future<PagePagination<PostModel>> paginate({
    @Queries()
    PagePaginationParams? paginationParams = const PagePaginationParams(),
  });

  @GET('/{wrId}')
  @Headers({'accessToken': 'true'})
  Future<PostDetailModel> getRiskDetail({
    @Path('wrId') required String wrId,
  });

  @POST('')
  @Headers({'accessToken': 'true', 'Content-Type': 'application/json'})
  Future<String?> postPost({@Body() required CreatePostDto dto});

  @PATCH('')
  @Headers({'accessToken': 'true', 'Content-Type': 'application/json'})
  Future<String?> patchPost({@Body() required CreatePostDto dto});
}
