import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lhens_app/department/model/department_model.dart';

import '../model/department_detail_model.dart';
import '../repository/department_repository.dart';

final departmentProvider =
    StateNotifierProvider<DepartmentStateNotifier, DepartmentModelBase?>((ref) {
      final repository = ref.watch(departmentRepositoryProvider);

      return DepartmentStateNotifier(ref: ref, repository: repository);
    });

class DepartmentStateNotifier extends StateNotifier<DepartmentModelBase?> {
  final Ref ref;
  final DepartmentRepository repository;

  DepartmentStateNotifier({required this.ref, required this.repository})
    : super(DepartmentModelLoading()) {
    getDepartments();
  }

  getDepartments() async {
    final resp = await repository.getDepartments();
    state = resp;
  }

  getDetail(int id) async {
    if (state is! DepartmentModelList) {
      await getDepartments();
    }
    if (state is! DepartmentModelList) {
      return;
    }

    final pState = state as DepartmentModelList;
    final resp = await repository.getMembers(id: id);  // DepartmentDetailModel

    // 트리 전체를 DFS로 돌면서 resp.id 와 같은 노드 교체
    _replaceNodeById(pState.data, resp);

    // 상태 변경 트리거 (최상위 리스트만 새 인스턴스로)
    state = DepartmentModelList(data: List.of(pState.data));
  }

  // resp.id 와 일치하는 노드를 찾으면 그 자리에서 resp 로 교체
// 찾았으면 true, 못 찾았으면 false 반환
  bool _replaceNodeById(List<DepartmentModel> list, DepartmentDetailModel resp) {
    for (var i = 0; i < list.length; i++) {
      final node = list[i];

      // 1) 현재 노드가 대상이면 교체
      if (node.id == resp.id) {
        list[i] = resp;
        return true;
      }

      // 2) 자식들 안에서 계속 탐색
      if (node.children.isNotEmpty) {
        final found = _replaceNodeById(node.children, resp);
        if (found) return true; // 이미 교체했으면 바로 종료
      }
    }
    return false;
  }
}
