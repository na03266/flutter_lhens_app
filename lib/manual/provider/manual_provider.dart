import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lhens_app/common/model/page_pagination_model.dart';
import 'package:lhens_app/common/provider/page_pagination_providar.dart';
import 'package:lhens_app/drawer/model/post_model.dart';
import 'package:lhens_app/manual/repository/manual_repository.dart';

final manualDetailProvider = Provider.family<PostModel?, String>((ref, id) {
  final state = ref.watch(manualProvider);
  if (state is! PagePagination) {
    return null;
  }

  return state.data.firstWhere((element) => element.wrId == int.parse(id));
});

final manualProvider = StateNotifierProvider<ManualStateNotifier, PagePaginationBase>(
      (ref) {
    final repository = ref.watch(manualRepositoryProvider);
    final notifier = ManualStateNotifier(repository: repository);

    return notifier;
  },
);

class ManualStateNotifier
    extends PagePaginationProvider<PostModel, ManualRepository> {
  ManualStateNotifier({required super.repository});

  getDetail({required String wrId}) async {
    if (state is! PagePagination) {
      await paginate();
    }
    if (state is! PagePagination) {
      return;
    }

    final pState = state as PagePagination;

    final resp = await repository.getManualDetail(wrId: wrId);

    final parsedWrId = int.parse(wrId);
    if (pState.data.where((e) => e.wrId == parsedWrId).isEmpty) {
      state = pState.copyWith(data: <PostModel>[...pState.data, resp]);
    } else {
      state = pState.copyWith(
        data: pState.data
            .map<PostModel>((e) => e.wrId == parsedWrId ? resp : e)
            .toList(),
      );
    }
  }
}
