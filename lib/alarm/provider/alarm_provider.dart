import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lhens_app/alarm/model/alarm_model.dart';
import 'package:lhens_app/alarm/repository/alarm_repository.dart';

final alarmProvider =
    StateNotifierProvider<AlarmStateNotifier, AlarmModelBase?>((ref) {
      final repository = ref.watch(alarmRepositoryProvider);
      return AlarmStateNotifier(ref: ref, repository: repository);
    });

class AlarmStateNotifier extends StateNotifier<AlarmModelBase?> {
  final Ref ref;
  final AlarmRepository repository;

  AlarmStateNotifier({required this.ref, required this.repository})
    : super(AlarmModelLoading()) {
    getItems();
  }

  Future<void> getItems({int? isRead}) async {
    final resp = isRead != null
        ? await repository.getItems(isRead: isRead)
        : await repository.getItems();
    state = resp;
  }

  int _optimisticSeq = 0;

  Future<void> makeAsRead({required String id}) async {
    final seq = ++_optimisticSeq;
    final prevState = state;

    // 1) 옵티미스틱 반영: 서버 응답 전에 UI 먼저 갱신
    if (prevState is AlarmModel) {
      final nextData = prevState.data
          .map((e) => e.id == id ? e.copyWith(isRead: true) : e)
          .toList();

      state = prevState.copyWith(data: nextData);
    }

    // 2) 서버 반영 시도
    try {
      await repository.markAsRead(id: id);
    } catch (e) {
      // 3) 실패 시 롤백: 최신 요청에 대해서만 롤백(경합 방지)
      if (seq == _optimisticSeq) {
        state = prevState;
      }
      rethrow;
    }
  }
}
