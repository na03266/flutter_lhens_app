import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lhens_app/chat/model/message_model.dart';
import 'package:lhens_app/common/const/data.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../user/auth/provider/auth_provider.dart';

final chatGatewayClientProvider = Provider<ChatGatewayClient?>((ref) {
  final baseUrl = ws;
  final jwt = ref.watch(authTokenProvider);
  if (jwt == null) return null;

  final client = ChatGatewayClient(baseUrl: baseUrl, jwt: jwt);
  client.connect(); // 로그인 시 자동 연결
  ref.onDispose(client.dispose); // 로그아웃/앱 종료 시 정리
  return client;
});

class ChatGatewayClient {
  final String baseUrl; // 예: http://110.10.147.37/app
  final String jwt;
  late final IO.Socket _socket;

  // 1) 메시지 스트림 (기존)
  final _messages = StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get messages => _messages.stream;

  // 2) 방 커서 전체 스냅샷(room:cursors)
  final _roomCursors = StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get roomCursors => _roomCursors.stream;

  // 3) 개별 커서 변경(cursor:updated)
  final _cursorUpdates = StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get cursorUpdates => _cursorUpdates.stream;

  // 4) 그룹 읽음 지표(room:read-progress) – 선택
  final _readProgress = StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get readProgress => _readProgress.stream;

  ChatGatewayClient({required this.baseUrl, required this.jwt});

  void connect() {
    // 네임스페이스는 /chat, Socket.IO path는 기본 /socket.io
    final url = '$baseUrl/chat'; // http://110.10.147.37/app/chat

    final builder = IO.OptionBuilder()
        .setTransports(['websocket'])
        .enableAutoConnect()
        .enableReconnection()
        .setPath('/app/socket.io');

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
      joinLobby();
    });

    _socket.onConnectError((e) => print('connect_error: $e'));
    _socket.onDisconnect((_) => print('disconnected'));
    _socket.on('error', (e) {
      print('gateway error: $e');
      // 정책에 따라 재연결 유지
    });

    // ───────── 서버 이벤트 매핑 ─────────
    _socket.on('ready', (_) => print('ready'));

    _socket.on('message:new', (data) {
      _messages.add(Map<String, dynamic>.from(data));
    });

    // 2) 방 커서 전체 (join-room 이후 room:cursors 이벤트 필요)
    _socket.on('room:cursors', (data) {
      print('room:cursors : init $data');

      _roomCursors.add(Map<String, dynamic>.from(data));
    });

    // 3) 특정 유저 커서 변경
    _socket.on('cursor:updated', (data) {
      print('cursor:updated $data');

      _cursorUpdates.add(Map<String, dynamic>.from(data));
    });

    // 4) 그룹 읽음 지표 (원하면 방 목록/헤더에서 사용)
    _socket.on('room:read-progress', (data) {
      _readProgress.add(Map<String, dynamic>.from(data));
    });

    _socket.on('room:update', (data) {
      // 목록/배지 갱신용 요약
      // print('room:update $data');
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

  void sendMessage(
    int roomId,
    String text, {
    String? tempId,
    MessageType? type,
    String? filePath,
  }) {
    _socket.emit('send-message', {
      'roomId': roomId,
      'message': text,
      'filePath': filePath ?? '',
      'messageType': type?.index ?? 1,
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
    try {
      Platform.isAndroid;
      return false;
    } catch (_) {
      return true;
    }
  }
}
