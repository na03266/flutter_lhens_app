import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lhens_app/common/const/data.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../user/auth/provider/auth_provider.dart';

final chatGatewayClientProvider = Provider<ChatGatewayClient?>((ref) {
  final baseUrl = ws;
  final jwt = ref.watch(authTokenProvider);
  if (jwt == null) return null;

  final client = ChatGatewayClient(baseUrl: baseUrl, jwt: jwt);
  client.connect();                   // 로그인 시 자동 연결
  ref.onDispose(client.dispose);      // 로그아웃/앱 종료 시 정리
  return client;
});

class ChatGatewayClient {
  final String baseUrl; // 예: https://api.example.com
  final String jwt;
  late final IO.Socket _socket;

  final _messages = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get messages => _messages.stream;

  ChatGatewayClient({required this.baseUrl, required this.jwt});

  void connect() {
    // 네임스페이스는 /chat, Socket.IO path는 기본 /socket.io
    final url = '$baseUrl/chat';

    final builder = IO.OptionBuilder()
        .setTransports(['websocket'])
        .enableAutoConnect()
        .enableReconnection()
        .setReconnectionDelay(500)
        .setReconnectionDelayMax(5000)
        .setTimeout(10000)
        .setPath('/socket.io');

    // 모바일/데스크톱 네이티브: 헤더 사용
    // 웹(Flutter Web): 헤더가 안 먹히므로 auth로 전달
    if (_isWeb) {
      builder.setAuth({'token': jwt});
    } else {
      builder.setExtraHeaders({'Authorization': 'Bearer $jwt'});
    }

    _socket = IO.io(url, builder.build());

    _socket.onConnect((_) {
      // 서버가 접속 즉시 'ready'를 emit합니다.
      // 필요 시 여기서 로비 조인
      // joinLobby();
    });

    _socket.onConnectError((e) => print('connect_error: $e'));
    _socket.onDisconnect((_) => print('disconnected'));
    _socket.on('error', (e) {
      print('gateway error: $e');
      // 정책에 따라 재연결 유지
    });

    // 서버 이벤트 매핑
    _socket.on('ready', (_) => print('ready'));
    _socket.on('message:new', (data) {
      _messages.add(Map<String, dynamic>.from(data));
    });
    _socket.on('room:update', (data) {
      // 목록/배지 갱신용 요약
      // print('room:update $data');
    });
    _socket.on('room:read-progress', (data) {
      // 그룹 읽음 지표
      // print('read-progress $data');
    });
    _socket.on('message:ack', (data) {
      // tempId 매칭하여 UI에서 pending→sent 전환
      // print('message:ack $data');
    });
    _socket.on('cursor:ack', (data) {
      // print('cursor:ack $data');
    });
  }

  void joinLobby() {
    _socket.emit('join-lobby');
  }

  void joinRoom(int roomId) {
    _socket.emit('join-room', {'roomId': roomId});
  }

  void leaveRoom(int roomId) {
    _socket.emit('leave-room', {'roomId': roomId});
  }

  void sendMessage(int roomId, String text, {String? tempId}) {
    _socket.emit('send-message', {
      'roomId': roomId,
      'message': text,
      if (tempId != null) 'tempId': tempId, // 서버가 ack 시 돌려줌
    });
  }

  void updateCursor(int roomId, {int? lastReadMessageId}) {
    _socket.emit('cursor:update', {
      'roomId': roomId,
      if (lastReadMessageId != null) 'lastReadMessageId': lastReadMessageId,
    });
  }

  void dispose() {
    _socket.dispose();
    _messages.close();
  }

  bool get _isWeb {
    // 간단 판별: dart:io Platform 사용 불가 시 웹로 간주
    try { Platform.isAndroid; return false; } catch (_) { return true; }
  }
}
