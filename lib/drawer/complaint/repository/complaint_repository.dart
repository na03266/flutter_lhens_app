import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lhens_app/chat/dto/create_chat_room_dto.dart';
import 'package:lhens_app/common/const/data.dart';
import 'package:lhens_app/common/dio/dio.dart';
import 'package:lhens_app/common/model/page_pagination_model.dart';
import 'package:lhens_app/common/model/page_pagination_params.dart';
import 'package:lhens_app/common/repository/base_pagination_repository.dart';
import 'package:lhens_app/drawer/model/create_post_dto.dart';
import 'package:lhens_app/drawer/model/post_detail_model.dart';
import 'package:lhens_app/drawer/model/post_model.dart';
import 'package:retrofit/retrofit.dart';

part 'complaint_repository.g.dart';

final complaintRepositoryProvider = Provider<ComplaintRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return ComplaintRepository(dio, baseUrl: '$ip/board-suggest');
});

@RestApi()
abstract class ComplaintRepository
    implements IBasePagePaginationRepository<PostModel> {
  factory ComplaintRepository(Dio dio, {String baseUrl}) = _ComplaintRepository;

  @override
  @GET('')
  @Headers({'accessToken': 'true'})
  Future<PagePagination<PostModel>> paginate({
    @Queries()
    PagePaginationParams? paginationParams = const PagePaginationParams(),
  });

  @GET('/{wrId}')
  @Headers({'accessToken': 'true'})
  Future<PostDetailModel> getComplaintDetail({
    @Path('wrId') required String wrId,
  });

  @POST('')
  @Headers({'accessToken': 'true', 'Content-Type': 'application/json'})
  Future<String?> postPost({@Body() required CreatePostDto dto});

  @POST('/comment')
  @Headers({'accessToken': 'true', 'Content-Type': 'application/json'})
  Future<String?> postComment({
    @Body() required CreatePostDto dto,
    @Query('parentId') required String parentId,
  });

  @POST('/comment/reply')
  @Headers({'accessToken': 'true', 'Content-Type': 'application/json'})
  Future<String?> postReComment({
    @Body() required CreatePostDto dto,
    @Query('parentId') required String parentId,
    @Query('commentId') required String commentId,
  });

  @PATCH('')
  @Headers({'accessToken': 'true', 'Content-Type': 'application/json'})
  Future<String?> patchPost({
    @Query('wrId') required String wrId,
    @Body() required CreatePostDto dto,
  });

  @PATCH('/pass')
  @Headers({'accessToken': 'true'})
  Future<String?> passOnPost({
    @Query('wrId') required String wrId,
    @Body() required CreateChatRoomDto dto,
  });

  @DELETE('')
  @Headers({'accessToken': 'true'})
  Future<String?> delete({@Query('wrId') required String wrId});
}
