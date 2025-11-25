import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lhens_app/common/model/page_pagination_model.dart';
import 'package:lhens_app/common/provider/page_pagination_providar.dart';
import 'package:lhens_app/drawer/edu_event/repository/edu_repository.dart';
import 'package:lhens_app/drawer/model/post_model.dart';

final eduDetailProvider = Provider.family<PostModel?, String>((ref, id) {
  final state = ref.watch(eduProvider);
  if (state is! PagePagination) {
    return null;
  }

  return state.data.firstWhere((element) => element.wrId == int.parse(id));
});

final eduProvider = StateNotifierProvider<EduStateNotifier, PagePaginationBase>(
  (ref) {
    final repository = ref.watch(eduRepositoryProvider);
    final notifier = EduStateNotifier(repository: repository);

    return notifier;
  },
);

class EduStateNotifier
    extends PagePaginationProvider<PostModel, EduRepository> {
  EduStateNotifier({required super.repository});

  getDetail({required String wrId}) async {
    if (state is! PagePagination) {
      await paginate();
    }
    if (state is! PagePagination) {
      return;
    }

    final pState = state as PagePagination;

    final resp = await repository.getEduDetail(wrId: wrId);

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
