import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lhens_app/common/model/page_pagination_params.dart';

import '../model/page_pagination_model.dart';
import '../repository/base_pagination_repository.dart';

class _PagePaginationInfo {
  final int take;
  final int page;
  final String caName;
  final String wr1;
  final String title;
  final int mineOnly; // ✅ 추가
  final bool fetchMore;
  final bool forceRefetch;

  _PagePaginationInfo({
    this.take = 10,
    this.page = 1,
    this.caName = '',
    this.wr1 = '',
    this.title = '',
    this.mineOnly = 0, // ✅ 추가
    this.fetchMore = false,
    this.forceRefetch = false,
  });
}

class PagePaginationProvider<T, U extends IBasePagePaginationRepository<T>>
    extends StateNotifier<PagePaginationBase> {
  final U repository;
  final paginationThrottle = Throttle(
    Duration(seconds: 3),
    initialValue: _PagePaginationInfo(),
    checkEquality: false,
  );

  PagePaginationProvider({required this.repository})
    : super(PagePaginationLoading()) {
    paginationThrottle.values.listen((state) {
      _throttledPaginate(state);
    });
    paginate();
  }

  Future<void> paginate({
    int fetchTake = 10,
    int fetchPage = 1,
    String caName = '',
    String wr1 = '',
    String title = '',
    int mineOnly = 0,
    bool fetchMore = false,
    bool forceRefetch = false,
  }) async {
    paginationThrottle.setValue(
      _PagePaginationInfo(
        take: fetchTake,
        page: fetchPage,
        fetchMore: fetchMore,
        forceRefetch: forceRefetch,
        caName: caName,
        mineOnly: mineOnly,
        wr1: wr1,
        title: title,
      ),
    );
  }

  _throttledPaginate(_PagePaginationInfo info) async {
    final fetchTake = info.take;
    final fetchPage = info.page;
    final fetchMore = info.fetchMore;
    final forceRefetch = info.forceRefetch;
    // 5가지 가능성
    // State의 상태
    // 1) PagePagination - 정상적으로 데이터가 있는 상태
    // 2) PagePaginationLoading - 데이터 로딩중(현재 캐시 없음
    // 3) PagePaginationError = 에러가 있는 상태
    // 4) PagePaginationRefetching = 첫번째 페이지부터 다시 데이터를 가져올때

    // 바로 반환하는 상황
    // 1) hasMore == false(기존 상태에서 이미 다음 데이터가 없다는 값을 들고 있다면)
    // 2) 로딩중 - fetchMore : true
    //     fetchMore : false  - 새로고침의 의도가 있음.
    try {
      //강제 새로 고침
      if (state is PagePagination && !forceRefetch) {
        final pState = state as PagePagination;

        //강제 새로 고침 예외
        if ((pState.meta.count / pState.meta.take).ceil() < pState.meta.page) {
          return;
        }
      }

      // 로딩중, 패치 중이면 무조건 스킵
      final isLoading = state is PagePaginationLoading;
      final isRefetching = state is PagePaginationRefetching;
      final isFetchingMore = state is PagePaginationFetchingMore;

      if (fetchMore && (isLoading || isRefetching || isFetchingMore)) {
        return;
      }

      // PagePaginationParams 생성
      PagePaginationParams paginationParams = PagePaginationParams(
        page: fetchPage,
        take: fetchTake,
        caName: info.caName,
        wr1: info.wr1,
        title: info.title,
        mineOnly: info.mineOnly,
      );

      state = PagePaginationLoading();
      final resp = await repository.paginate(
        paginationParams: paginationParams,
      );

      // 기존 데이터와 교체
      if (state is PagePaginationFetchingMore) {
        state = resp.copyWith(data: resp.data);
      } else {
        state = resp;
      }
    } catch (e, stack) {
      print(e);
      print(stack);
      state = PagePaginationError(message: '데이터를 가져오지 못했습니다.');
    }
  }
}
