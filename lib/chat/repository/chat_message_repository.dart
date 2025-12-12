import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lhens_app/chat/model/message_model.dart';
import 'package:lhens_app/common/const/data.dart';
import 'package:lhens_app/common/dio/dio.dart';
import 'package:lhens_app/common/model/cursor_pagination_model.dart';
import 'package:lhens_app/common/model/cursor_pagination_params.dart';
import 'package:retrofit/retrofit.dart';

part 'chat_message_repository.g.dart';

/// roomId는 Provider.family로 넘기고,
/// 실제 HTTP 요청에서는 @Query('roomId') 로 붙임
final chatMessageRepositoryProvider = Provider<ChatMessageRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return ChatMessageRepository(dio, baseUrl: '$ip/messages');
});

@RestApi()
abstract class ChatMessageRepository {
  factory ChatMessageRepository(Dio dio, {String baseUrl}) =
      _ChatMessageRepository;

  @GET('')
  @Headers({'accessToken': 'true'})
  Future<CursorPagination<MessageModel>> paginate({
    @Query('roomId') required String roomId,
    @Queries()
    CursorPaginationParams paginationParams = const CursorPaginationParams(),
  });

  @POST('')
  @Headers({'accessToken': 'true', 'Content-Type': 'application/json'})
  Future<String?> createChatMessage({
    @Body() required Map<String, dynamic> dto,
  });

  @PATCH('/{id}')
  @Headers({'accessToken': 'true', 'Content-Type': 'application/json'})
  Future<String> patchChatMessage({
    @Path('id') required String id,
    @Body() required Map<String, dynamic> dto,
  });

  @GET('/{id}')
  @Headers({'accessToken': 'true'})
  Future<MessageModel> getChatMessageDetail({@Path('id') required String id});
}
