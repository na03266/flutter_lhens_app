import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lhens_app/drawer/edu_event/repository/edu_repository.dart';
import 'package:lhens_app/drawer/notice/repository/notice_repository.dart';
import 'package:lhens_app/home/model/home_model.dart';

import '../../common/model/page_pagination_params.dart';

final homeProvider = StateNotifierProvider<HomeStateNotifier, HomeModelBase>((
  ref,
) {
  final noticeRepository = ref.watch(noticeRepositoryProvider);
  final eduRepository = ref.watch(eduRepositoryProvider);
  final notifier = HomeStateNotifier(
    noticeRepository: noticeRepository,
    eduRepository: eduRepository,
  );

  return notifier;
});

class HomeStateNotifier extends StateNotifier<HomeModelBase> {
  final NoticeRepository noticeRepository;
  final EduRepository eduRepository;

  HomeStateNotifier({
    required this.noticeRepository,
    required this.eduRepository,
  }) : super(HomeModelLoading()) {
    initialize();
  }

  Future<void> initialize() async {
    final noticeResp = await noticeRepository.paginate(
      paginationParams: PagePaginationParams(take: 2, page: 1),
    );
    final eduResp = await eduRepository.paginate(
      paginationParams: PagePaginationParams(take: 10, page: 1),
    );
    state = HomeModel(noticeItems: noticeResp.data, eventItems: eduResp.data);
  }

}
