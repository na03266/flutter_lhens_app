// providers/chat_providers.dart
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repository/chat_socket.dart'; // 앞서 만든 ChatGatewayClient

final chatMessagesProvider = StreamProvider<Map<String, dynamic>>((ref) {
  final client = ref.watch(chatGatewayClientProvider);
  if (client == null) return const Stream.empty();
  return client.messages;
});

// 액션 집합(조인, 전송, 커서 업데이트)
class ChatActions {
  final ChatGatewayClient c;
  ChatActions(this.c);
  void joinLobby() => c.joinLobby();
  void joinRoom(int roomId) => c.joinRoom(roomId);
  void leaveRoom(int roomId) => c.leaveRoom(roomId);
  void send(int roomId, String text, {String? tempId}) => c.sendMessage(roomId, text, tempId: tempId);
  void updateCursor(int roomId, {int? lastReadMessageId}) =>
      c.updateCursor(roomId, lastReadMessageId: lastReadMessageId);
}

final chatActionsProvider = Provider<ChatActions?>((ref) {
  final client = ref.watch(chatGatewayClientProvider);
  return client == null ? null : ChatActions(client);
});
