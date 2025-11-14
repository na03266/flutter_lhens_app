import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lhens_app/common/model/page_pagination_model.dart';
import 'package:lhens_app/common/provider/page_pagination_providar.dart';
import 'package:lhens_app/drawer/notice/model/notice_model.dart';
import 'package:lhens_app/drawer/notice/repository/notice_repository.dart';

final noticeDetailProvider = Provider.family<NoticeModel?, String>((ref, id) {
  final state = ref.watch(noticeProvider);

  if (state is! PagePagination) {
    return null;
  }

  return state.data.firstWhere((element) => element.id == id);
});

final noticeProvider =
    StateNotifierProvider<NoticeStateNotifier, PagePaginationBase>((ref) {
      final repository = ref.watch(noticeRepositoryProvider);
      final notifier = NoticeStateNotifier(repository: repository);

      return notifier;
    });

class NoticeStateNotifier
    extends PagePaginationProvider<NoticeModel, NoticeRepository> {

  NoticeStateNotifier({required super.repository});

  getDetail({required String wrId}) async {
    if (state is! PagePagination) {
      await paginate();
    }
    if (state is! PagePagination) {
      return;
    }

    final pState = state as PagePagination;

    final resp = await repository.getNoticeDetail(wrId: wrId);
    if (pState.data.where((e) => e.wrId == wrId).isEmpty) {
      state = pState.copyWith(data: <NoticeModel>[...pState.data, resp]);
    } else {
      state = pState.copyWith(
        data: pState.data
            .map<NoticeModel>((e) => e.wrId == wrId ? resp : e)
            .toList(),
      );
    }
  }
}
