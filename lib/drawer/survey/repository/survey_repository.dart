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
import 'package:lhens_app/drawer/survey/model/join_survey_dto.dart';
import 'package:lhens_app/drawer/survey/model/survey_detail_model.dart';
import 'package:lhens_app/drawer/survey/model/survey_model.dart';
import 'package:lhens_app/drawer/survey/model/survey_model.dart';
import 'package:retrofit/retrofit.dart';

part 'survey_repository.g.dart';

final surveyRepositoryProvider = Provider<SurveyRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return SurveyRepository(dio, baseUrl: '$ip/survey');
});

@RestApi()
abstract class SurveyRepository
    implements IBasePagePaginationRepository<SurveyModel> {
  factory SurveyRepository(Dio dio, {String baseUrl}) = _SurveyRepository;

  @override
  @GET('')
  @Headers({'accessToken': 'true'})
  Future<PagePagination<SurveyModel>> paginate({
    @Queries()
    PagePaginationParams? paginationParams = const PagePaginationParams(),
  });

  @GET('/{poId}')
  @Headers({'accessToken': 'true'})
  Future<SurveyDetailModel> getSurveyDetail({
    @Path('poId') required String poId,
  });

  @POST('/{poId}')
  @Headers({'accessToken': 'true'})
  Future<String> joinSurvey({
    @Path('poId') required String poId,
    @Body() required Map<String, dynamic> answers,
  });
}
