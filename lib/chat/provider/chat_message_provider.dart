// family 로 roomId를 받아서 방마다 별도 상태 관리
// chat_message_provider.dart
import 'dart:math';

import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lhens_app/user/model/user_model.dart';

import '../../common/model/cursor_pagination_model.dart';
import '../../common/model/cursor_pagination_params.dart';
import '../model/message_model.dart';
import '../repository/chat_message_repository.dart';

class _MessagePaginationInfo {
  final int fetchCount;
  final bool fetchMore;
  final List<String> fetchOrder;
  final bool forceRefetch;

  const _MessagePaginationInfo({
    this.fetchCount = 20,
    this.fetchMore = false,
    this.fetchOrder = const ['id_DESC'],
    this.forceRefetch = false,
  });
}

final chatMessageProvider =
    StateNotifierProvider.family<
      ChatMessageStateNotifier,
      CursorPaginationBase,
      String
    >((ref, roomId) {
      final repo = ref.watch(chatMessageRepositoryProvider);
      return ChatMessageStateNotifier(repository: repo, roomId: roomId);
    });

class ChatMessageStateNotifier extends StateNotifier<CursorPaginationBase> {
  final ChatMessageRepository repository;
  final String roomId;

  // 방별로 독립적인 throttle
  final Throttle<_MessagePaginationInfo> _paginationThrottle =
      Throttle<_MessagePaginationInfo>(
        const Duration(seconds: 3),
        initialValue: const _MessagePaginationInfo(),
        checkEquality: false,
      );

  ChatMessageStateNotifier({required this.repository, required this.roomId})
    : super(CursorPaginationLoading()) {
    _paginationThrottle.values.listen(_throttledPaginate);
    // 생성 시 첫 페이지 자동 로딩
    paginate();
  }

  /// 외부에서 호출하는 메서드
  Future<void> paginate({
    int fetchCount = 20,
    bool fetchMore = false,
    List<String> fetchOrder = const ['id_DESC'],
    bool forceRefetch = false,
  }) async {
    _paginationThrottle.setValue(
      _MessagePaginationInfo(
        fetchCount: fetchCount,
        fetchMore: fetchMore,
        fetchOrder: fetchOrder,
        forceRefetch: forceRefetch,
      ),
    );
  }

  Future<void> _throttledPaginate(_MessagePaginationInfo info) async {
    final fetchCount = info.fetchCount;
    final fetchMore = info.fetchMore;
    final fetchOrder = info.fetchOrder;
    final forceRefetch = info.forceRefetch;

    try {
      // 다음 페이지 없음 + 강제 새로고침이 아니면 바로 종료
      if (state is CursorPagination && !forceRefetch) {
        final pState = state as CursorPagination<MessageModel>;
        if (pState.meta.nextCursor == null) {
          return;
        }
      }

      final isLoading = state is CursorPaginationLoading;
      final isRefetching = state is CursorPaginationRefetching;
      final isFetchingMore = state is CursorPaginationFetchingMore;

      // 추가 로딩 중복 방지
      if (fetchMore && (isLoading || isRefetching || isFetchingMore)) {
        return;
      }

      // 기본 파라미터
      CursorPaginationParams params = CursorPaginationParams(
        take: fetchCount,
        order: fetchOrder,
      );

      // fetchMore 인 경우 cursor 세팅 + 상태 전환
      if (fetchMore && state is CursorPagination<MessageModel>) {
        final pState = state as CursorPagination<MessageModel>;

        state = CursorPaginationFetchingMore<MessageModel>(
          meta: pState.meta,
          data: pState.data,
        );

        params = params.copyWith(cursor: pState.meta.nextCursor);
      } else if (!fetchMore && !forceRefetch) {
        // 첫 로딩이 아니고, 단순 새로고침이면 Refetching 상태로 둬도 됨(선택)
        // state = CursorPaginationRefetching<MessageModel>(meta: ..., data: ...);
      }

      // 실제 API 호출
      final resp = await repository.paginate(
        roomId: roomId,
        paginationParams: params,
      );

      if (state is CursorPaginationFetchingMore<MessageModel>) {
        final pState = state as CursorPaginationFetchingMore<MessageModel>;

        // 1) 이전 데이터 + 새 데이터 합치기
        final merged = <MessageModel>[...pState.data, ...resp.data];

        // 2) createdAt 기준으로 정렬 (오래된 → 최신)
        merged.sort((a, b) {
          final da = DateTime.tryParse(a.createdAt) ?? DateTime(1970);
          final db = DateTime.tryParse(b.createdAt) ?? DateTime(1970);
          return da.compareTo(db);
        });

        // 3) 정렬된 결과로 상태 갱신
        state = resp.copyWith(
          data: merged,
          // meta 는 서버 응답 기준 유지
        );
      } else {
        final sorted = [...resp.data]
          ..sort((a, b) {
            final da = DateTime.tryParse(a.createdAt) ?? DateTime(1970);
            final db = DateTime.tryParse(b.createdAt) ?? DateTime(1970);
            return da.compareTo(db);
          });

        state = resp.copyWith(data: sorted);
      }
    } catch (e, stack) {
      print(e);
      print(stack);
      state = CursorPaginationError(message: '채팅 메시지를 가져오지 못했습니다.');
    }
  }

  // -----------------------------
  // 2) 소켓/로컬에서 메시지 주입
  // -----------------------------

  /// 소켓으로 새 메시지가 들어왔을 때 사용
  void addIncomingMessage(MessageModel msg) {
    // 1) 아직 페이지네이션 상태가 아니면 새로 시작
    if (state is! CursorPagination<MessageModel>) {
      state = CursorPagination<MessageModel>(
        meta: CursorPaginationMeta(nextCursor: null, count: 1),
        data: [msg],
      );
      return;
    }

    final p = state as CursorPagination<MessageModel>;

    // 2) tempId 기준으로 pending 교체 시도
    if (msg.tempId != null) {
      final idx = p.data.indexWhere((e) => e.tempId == msg.tempId);
      if (idx != -1) {
        final newList = [...p.data];
        // 서버 메시지가 실제 id, createdAt, 기타 필드를 덮어쓰게 함
        newList[idx] = msg;

        state = p.copyWith(
          data: newList,
          // 교체니까 count 는 그대로
          meta: p.meta,
        );
        return;
      }
    }

    // 3) tempId 로 못 찾았으면 id 기준 중복 방지
    final existsById = p.data.any((e) => e.id == msg.id);
    if (existsById) {
      return;
    }

    // 4) 완전히 새로운 메시지면 append + count++
    state = p.copyWith(
      data: [...p.data, msg],
      meta: p.meta.copyWith(count: p.meta.count + 1),
    );
  }

  /// 내가 보낸 메시지를 서버 응답 전에 먼저 화면에 보여주고 싶을 때
  void addLocalPendingMessage({
    required String text,
    required String tempId,
    required UserModel me,
    MessageType? type,
    String? filePath,
  }) {
    final now = DateTime.now().toIso8601String();

    final local = MessageModel(
      id: tempId,
      author: me,
      content: text,
      createdAt: now,
      filePath: filePath ?? '',
      type: type ?? MessageType.TEXT,
      tempId: tempId,
    );

    addIncomingMessage(local);
  }

  /// 서버가 ACK를 보내오면서 tempId -> 실제 DB id를 알려줄 때 사용
  void ackMessage({required String tempId, required String realId}) {
    if (state is! CursorPagination<MessageModel>) return;

    final p = state as CursorPagination<MessageModel>;

    state = p.copyWith(
      data: p.data
          .map((m) => m.id == tempId ? m.copyWith(id: realId) : m)
          .toList(),
    );
  }

  Future<void> deleteMessage(String id) async {
    await repository.deleteMessage(id: id);
    if (state is! CursorPagination<MessageModel>) return;
    final p = state as CursorPagination<MessageModel>;

    final newList = p.data.where((m) => m.id != id).toList();

    state = p.copyWith(
      data: newList,
      meta: p.meta.copyWith(count: p.meta.count - 1),
    );
  }
}
