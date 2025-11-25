import 'dart:ffi';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/model/cursor_pagination_model.dart';
import '../../common/provider/pagination_providar.dart';
import '../model/chat_room_model.dart';
import '../model/create_chat_room_dto.dart';
import '../repository/chat_room_repository.dart';

final chatRoomDetailProvider = Provider.family<ChatRoom?, String>((ref, id) {
  final state = ref.watch(chatRoomProvider);

  if (state is! CursorPagination) {
    return null;
  }

  return state.data.firstWhere((element) => element.id == id);
});

final chatRoomProvider =
    StateNotifierProvider<ChatRoomStateNotifier, CursorPaginationBase>((ref) {
      final repository = ref.watch(chatRoomRepositoryProvider);

      final notifier = ChatRoomStateNotifier(repository: repository);

      return notifier;
    });

class ChatRoomStateNotifier
    extends PaginationProvider<ChatRoom, ChatRoomRepository> {
  ChatRoomStateNotifier({required super.repository});

  createChatRoom({required CreateChatRoomDto dto}) async {
    final resp = await repository.createChatRoom(dto: dto);
    if (resp is Int) {
      paginate(forceRefetch: true);
    }
  }

  // getDetail({
  //   required String id,
  // }) async {
  //   if (state is! CursorPagination) {
  //     await paginate();
  //   }
  //   if (state is! CursorPagination) {
  //     return;
  //   }
  //
  //   final pState = state as CursorPagination;
  //
  //   final resp = await repository.getChatRoomDetail(id: id);
  //   if (pState.data.where((e) => e.id == id).isEmpty) {
  //     state = pState.copyWith(
  //       data: <ChatRoom>[
  //         ...pState.data,
  //         resp,
  //       ],
  //     );
  //   } else {
  //     state = pState.copyWith(
  //         data: pState.data
  //             .map<ChatRoom>(
  //               (e) => e.id == id ? resp : e,
  //         )
  //             .toList());
  //   }
  // }
}
