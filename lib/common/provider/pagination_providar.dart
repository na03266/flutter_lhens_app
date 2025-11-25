import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/cursor_pagination_model.dart';
import '../model/cursor_pagination_params.dart';
import '../repository/base_pagination_repository.dart';

class _PaginationInfo {
  final int fetchCount;
  final List<String> fetchOrder;
  final bool fetchMore;
  final bool forceRefetch;

  _PaginationInfo({
    this.fetchCount = 20,
    this.fetchMore = false,
    this.fetchOrder = const ['id_DESC'],
    this.forceRefetch = false,
  });
}

class PaginationProvider<T, U extends IBaseCursorPaginationRepository<T>>
    extends StateNotifier<CursorPaginationBase> {
  final U repository;
  final paginationThrottle = Throttle(
    Duration(seconds: 3),
    initialValue: _PaginationInfo(),
    checkEquality: false,
  );

  PaginationProvider({required this.repository})
    : super(CursorPaginationLoading()) {
    paginationThrottle.values.listen((state) {
      _throttledPaginate(state);
    });
    paginate();
  }

  Future<void> paginate({
    int fetchCount = 20,
    // 추가로 데이터 더 가져오기
    // true = 더 가져오기
    // false = 새로고침
    bool fetchMore = false,
    List<String> fetchOrder = const ['roomId_DESC'],
    // 강제로 다시 로딩하기
    // true - CursorPaginationLoading()
    bool forceRefetch = false,
  }) async {
    paginationThrottle.setValue(
      _PaginationInfo(
        fetchCount: fetchCount,
        fetchMore: fetchMore,
        fetchOrder: fetchOrder,
        forceRefetch: forceRefetch,
      ),
    );
  }

  _throttledPaginate(_PaginationInfo info) async {
    final fetchCount = info.fetchCount;
    final fetchMore = info.fetchMore;
    final fetchOrder = info.fetchOrder;
    final forceRefetch = info.forceRefetch;
    // 5가지 가능성
    // State의 상태
    // 1) CursorPagination - 정상적으로 데이터가 있는 상태
    // 2) CursorPaginationLoading - 데이터 로딩중(현재 캐시 없음
    // 3) CursorPaginationError = 에러가 있는 상태
    // 4) CursorPaginationRefetching = 첫번째 페이지부터 다시 데이터를 가져올때
    // 5) CursorPaginationFetchMore - 추가 데이터를 paginate 해오라는 요청을 받았을때

    // 바로 반환하는 상황
    // 1) hasMore == false(기존 상태에서 이미 다음 데이터가 없다는 값을 들고 있다면)
    // 2) 로딩중 - fetchMore : true
    //     fetchMore : false  - 새로고침의 의도가 있음.
    try {
      if (state is CursorPagination && !forceRefetch) {
        final pState = state as CursorPagination;

        if (pState.meta.nextCursor == null) {
          return;
        }
      }
      final isLoading = state is CursorPaginationLoading;
      final isRefetching = state is CursorPaginationRefetching;
      final isFetchingMore = state is CursorPaginationFetchingMore;

      if (fetchMore && (isLoading || isRefetching || isFetchingMore)) {
        return;
      }

      // PaginationParams 생성
      CursorPaginationParams paginationParams = CursorPaginationParams(
        take: fetchCount,
        order: fetchOrder,
      );

      // fetchMore
      if (fetchMore) {
        final pState = state as CursorPagination<T>;

        state = CursorPaginationFetchingMore<T>(
          meta: pState.meta,
          data: pState.data,
        );

        paginationParams = paginationParams.copyWith(
          cursor: pState.meta.nextCursor,
        );
      }

      final resp = await repository.paginate(
        paginationParams: paginationParams,
      );

      if (state is CursorPaginationFetchingMore) {
        final pState = state as CursorPaginationFetchingMore<T>;

        // 기존 데이터에 새로운 데이터 추가
        state = resp.copyWith(data: [...pState.data, ...resp.data]);
      } else {
        state = resp;
      }
    } catch (e, stack) {
      print(e);
      print(stack);
      state = CursorPaginationError(message: '데이터를 가져오지 못했습니다.');
    }
  }
}
