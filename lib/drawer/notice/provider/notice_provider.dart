import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/notice_model.dart';
import '../repository/board_repository.dart';

final noticeProvider = StateNotifierProvider<NoticeStateNotifier, NoticeState>((ref) {
  final repository = ref.watch(boardRepositoryProvider);
  return NoticeStateNotifier(
    repository: repository
  );
});

class NoticeStateNotifier extends StateNotifier<NoticeState> {
  final BoardRepository repository;

  NoticeStateNotifier({
    required this.repository
  }) : super(NoticeState()){
    fetchNoticeList();
  }

  // list
  Future<void> fetchNoticeList() async {
    print("fetchNoticeList11");
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      final List<NoticeModel> notices = await repository.getNoticeList();

      // print('state: ${state}');
      // print('notices: ${notices}');
      state = state.copyWith(
        notices: notices,
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load notices: $e',
      );
    }
  }

  // BoardList에서 사용할 형식으로 변환
  List<Map<String, dynamic>> getNoticeListForBoard() {
    return state.notices.map((notice) => notice.toBoardListFormat()).toList();
  }
}

class NoticeState {
  final List<NoticeModel> notices;
  final bool isLoading;
  final String? error;

  NoticeState({
    this.notices = const [],
    this.isLoading = false,
    this.error,
  });

  NoticeState copyWith({
    List<NoticeModel>? notices,
    bool? isLoading,
    String? error,
  }) {
    return NoticeState(
      notices: notices ?? this.notices,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}