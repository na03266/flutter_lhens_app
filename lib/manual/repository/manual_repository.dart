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


part 'manual_repository.g.dart';

final manualRepositoryProvider = Provider<ManualRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return ManualRepository(dio, baseUrl: '$ip/board-manual');
});

@RestApi()
abstract class ManualRepository
    implements IBasePagePaginationRepository<PostModel> {
  factory ManualRepository(Dio dio, {String baseUrl}) = _ManualRepository;

  @override
  @GET('')
  @Headers({'accessToken': 'true'})
  Future<PagePagination<PostModel>> paginate({
    @Queries()
    PagePaginationParams? paginationParams = const PagePaginationParams(),
  });

  @GET('/{wrId}')
  @Headers({'accessToken': 'true'})
  Future<PostDetailModel> getManualDetail({
    @Path('wrId') required String wrId,
  });
}
