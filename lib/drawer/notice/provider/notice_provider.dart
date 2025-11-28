import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lhens_app/common/model/page_pagination_model.dart';
import 'package:lhens_app/common/provider/page_pagination_providar.dart';
import 'package:lhens_app/drawer/model/post_model.dart';
import 'package:lhens_app/drawer/notice/repository/notice_repository.dart';

import '../../model/create_post_dto.dart';

final noticeDetailProvider = Provider.family<PostModel?, String>((ref, id) {
  final state = ref.watch(noticeProvider);
  if (state is! PagePagination) {
    return null;
  }

  return state.data.firstWhere((element) => element.wrId == int.parse(id));
});

final noticeProvider =
    StateNotifierProvider<NoticeStateNotifier, PagePaginationBase>((ref) {
      final repository = ref.watch(noticeRepositoryProvider);
      final notifier = NoticeStateNotifier(repository: repository);

      return notifier;
    });

class NoticeStateNotifier
    extends PagePaginationProvider<PostModel, NoticeRepository> {
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

  postPost({required CreatePostDto dto}) async {
    final resp = await repository.postPost(dto: dto);
    if (resp != null) {
      paginate(forceRefetch: true);
    }
  }

  patchPost({required int wrId, required CreatePostDto dto}) async {
    await repository.patchPost(wrId: wrId.toString(), dto: dto);
    await getDetail(wrId: wrId.toString());
  }

  postComment({required int wrId, required CreatePostDto dto}) async {
    await repository.postComment(parentId: wrId.toString(), dto: dto);
    await getDetail(wrId: wrId.toString());
  }

  postReComment({
    required int wrId,
    required int coId,
    required CreatePostDto dto,
  }) async {
    await repository.postReComment(
      parentId: wrId.toString(),
      commentId: coId.toString(),
      dto: dto,
    );
    await getDetail(wrId: wrId.toString());
  }
}
