import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lhens_app/drawer/notice/repository/notice_repository.dart';
import 'package:lhens_app/home/model/home_model.dart';

import '../../common/model/page_pagination_params.dart';

final homeProvider = StateNotifierProvider<HomeStateNotifier, HomeModelBase>((
  ref,
) {
  final noticeRepository = ref.watch(noticeRepositoryProvider);
  final notifier = HomeStateNotifier(noticeRepository: noticeRepository);

  return notifier;
});

class HomeStateNotifier extends StateNotifier<HomeModelBase> {
  final NoticeRepository noticeRepository;

  HomeStateNotifier({required this.noticeRepository})
    : super(HomeModelLoading()) {
    initialize();
  }

  Future<void> initialize() async {
    final noticeResp = await noticeRepository.paginate(
      paginationParams: PagePaginationParams(take: 2, page: 1),
    );
    state = HomeModel(noticeItems: noticeResp.data);
  }

}
