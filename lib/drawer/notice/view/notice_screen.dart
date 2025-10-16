import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lhens_app/common/components/report/report_list_scaffold.dart';
import 'package:lhens_app/common/components/report/report_list_config.dart';
import 'package:lhens_app/common/components/report/base_report_item_props.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/drawer/notice/view/notice_detail_screen.dart';

class NoticeScreen extends ConsumerWidget {
  static String get routeName => '공지사항';

  const NoticeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ReportListConfig<_NoticeItem>(
      tabs: const ['내부 공지사항', '외부 공지사항'],
      filters: const ['전체'],
      emptyMessage: (tab, {required bool mineOnly}) => switch (tab) {
        1 => mineOnly ? '등록한 공개 제안이 없습니다.' : '등록된 공개 제안이 없습니다.',
        2 => mineOnly ? '등록한 비공개 제안이 없습니다.' : '등록된 비공개 제안이 없습니다.',
        _ => mineOnly ? '등록한 제안이 없습니다.' : '등록된 제안이 없습니다.',
      },
      showFab: false,
      detailRouteName: NoticeDetailScreen.routeName,
      myDetailRouteName: null,
      formRouteName: '',
      load: () async => _mockNotices(),
      tabPredicate: (e, tab) => switch (tab) {
        1 => e.category == '내부공지사항',
        2 => e.category == '외부공지사항',
        _ => true,
      },
      searchPredicate: (e, f, q) {
        if (q.isEmpty) return true;
        final qq = q.toLowerCase();
        return e.title.toLowerCase().contains(qq) ||
            e.author.toLowerCase().contains(qq) ||
            e.category.toLowerCase().contains(qq);
      },
      mapToProps: (e) => ReportListItemProps(
        status: null,
        typeName: e.category,
        title: e.title,
        author: e.author,
        dateText: e.createdAt,
        secret: false,
      ),
      mineOnlyPredicate: null,
      onItemTap: (ctx, item) => ctx.pushNamed(NoticeDetailScreen.routeName),
    );

    return Scaffold(
      backgroundColor: AppColors.white,
      body: ReportListScaffold<_NoticeItem>(config: config),
    );
  }

  List<_NoticeItem> _mockNotices() => const [
    _NoticeItem(
      category: '외부공지사항',
      title: "[보도자료] LH E&S, 폭염 속 '온열질환 예방'에 총력",
      author: '조예빈(1001599)',
      createdAt: '2025. 08. 28',
    ),
    _NoticeItem(
      category: '외부공지사항',
      title: "[보도자료] LH E&S, '상호존중 갑질근절 GO~ STOP!' 캠페인 실시",
      author: '김찬주(1001655)',
      createdAt: '2025. 08. 14',
    ),
    _NoticeItem(
      category: '외부공지사항',
      title: 'LH E&S 소식통(通信) 소식지 제2025-2호 발행',
      author: '조예빈(1001599)',
      createdAt: '2025. 07. 25',
    ),
    _NoticeItem(
      category: '외부공지사항',
      title: '[보도자료] LH E&S, 밀폐공간 긴급구조 훈련 실시',
      author: 'LH E&S',
      createdAt: '2025. 07. 25',
    ),
    _NoticeItem(
      category: '외부공지사항',
      title: '한국폴리텍IV대학 대전캠퍼스, 2024년도 직원역량강화 우수기관 인증패 수여',
      author: '심명호(1000942)',
      createdAt: '2024. 11. 21',
    ),
  ];
}

class _NoticeItem {
  final String category;
  final String title;
  final String author;
  final String createdAt;

  const _NoticeItem({
    required this.category,
    required this.title,
    required this.author,
    required this.createdAt,
  });
}
