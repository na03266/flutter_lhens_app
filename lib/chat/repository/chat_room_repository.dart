import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lhens_app/chat/model/chat_room_model.dart';
import 'package:lhens_app/chat/model/create_chat_room_dto.dart';
import 'package:lhens_app/common/const/data.dart';
import 'package:lhens_app/common/dio/dio.dart';
import 'package:lhens_app/common/model/cursor_pagination_model.dart';
import 'package:lhens_app/common/model/cursor_pagination_params.dart';
import 'package:lhens_app/common/repository/base_pagination_repository.dart';
import 'package:lhens_app/drawer/model/post_detail_model.dart';
import 'package:retrofit/retrofit.dart';

part 'chat_room_repository.g.dart';

final chatRoomRepositoryProvider = Provider<ChatRoomRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return ChatRoomRepository(dio, baseUrl: '$ip/room');
});

@RestApi()
abstract class ChatRoomRepository
    implements IBaseCursorPaginationRepository<ChatRoom> {
  factory ChatRoomRepository(Dio dio, {String baseUrl}) = _ChatRoomRepository;

  @override
  @GET('')
  @Headers({'accessToken': 'true'})
  Future<CursorPagination<ChatRoom>> paginate({
    @Queries()
    CursorPaginationParams? paginationParams = const CursorPaginationParams(),
  });

  @POST('')
  @Headers({'accessToken': 'true', 'Content-Type': 'application/json'})
  Future<String?> createChatRoom({@Body() required CreateChatRoomDto dto});

  @GET('/')
  @Headers({'accessToken': 'true'})
  Future<List<PostDetailModel>> getChatRooms();
}
