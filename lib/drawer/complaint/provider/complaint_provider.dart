import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lhens_app/common/model/page_pagination_model.dart';
import 'package:lhens_app/common/provider/page_pagination_providar.dart';
import 'package:lhens_app/drawer/model/create_post_dto.dart';
import 'package:lhens_app/drawer/model/post_model.dart';
import 'package:lhens_app/drawer/complaint/repository/complaint_repository.dart';

final complaintDetailProvider = Provider.family<PostModel?, String>((ref, id) {
  final state = ref.watch(complaintProvider);
  if (state is! PagePagination) {
    return null;
  }

  return state.data.firstWhere((element) => element.wrId == int.parse(id));
});

final complaintProvider =
    StateNotifierProvider<ComplaintStateNotifier, PagePaginationBase>((ref) {
      final repository = ref.watch(complaintRepositoryProvider);
      final notifier = ComplaintStateNotifier(repository: repository);

      return notifier;
    });

class ComplaintStateNotifier
    extends PagePaginationProvider<PostModel, ComplaintRepository> {
  ComplaintStateNotifier({required super.repository});

  getDetail({required String wrId}) async {
    if (state is! PagePagination) {
      await paginate();
    }
    if (state is! PagePagination) {
      return;
    }

    final pState = state as PagePagination;

    final resp = await repository.getComplaintDetail(wrId: wrId);

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
  deletePost({required String wrId}) async {
    await repository.delete(wrId: wrId);
    await paginate(forceRefetch: true);
  }
  deleteReply({required String wrId}) async {
    await repository.delete(wrId: wrId);
  }
}
