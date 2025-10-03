import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lhens_app/common/components/app_segmented_tabs.dart';
import 'package:lhens_app/common/components/count_inline.dart';
import 'package:lhens_app/common/components/base_list_item.dart';
import 'package:lhens_app/common/components/search/filter_search_bar.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_shadows.dart';

class NoticeScreen extends ConsumerStatefulWidget {
  static String get routeName => '공지사항';
  const NoticeScreen({super.key});

  @override
  ConsumerState<NoticeScreen> createState() => _NoticeScreenState();
}

class _NoticeScreenState extends ConsumerState<NoticeScreen> {
  // 탭: 전체 / 내부 공지사항 / 외부 공지사항
  int _tabIndex = 0;

  // 검색
  final _query = TextEditingController();
  String _appliedQuery = '';
  final _filters = const ['전체']; // 스샷처럼 단일 필터
  String _selectedFilter = '전체';

  bool _scrolled = false;

  // ===== Mock 데이터 =====
  late final List<({
  String typeName, // 내부/외부 공지사항
  String title,
  String author,
  String dateText,
  })> _items = [
    (typeName: '외부공지사항', title: '[보도자료] LH E&S, 폭염 속 \'온열질환 예방\'에 총력', author: '조예빈(1001599)', dateText: '2025. 08. 28'),
    (typeName: '외부공지사항', title: "[보도자료] LH E&S, '상호존중 갑질근절 GO~ STOP!',캠페인 실시", author: '김한주(1001655)', dateText: '2025. 08. 14'),
    (typeName: '외부공지사항', title: 'LH E&S 소식통(通信) 소식지 제2025-2호 발행', author: '조예빈(1001599)', dateText: '2025. 07. 25'),
    (typeName: '외부공지사항', title: '[보도자료] LH E&S, 밀폐공간 긴급구조 훈련 실시', author: 'LH E&S', dateText: '2025. 07. 25'),
    (typeName: '외부공지사항', title: '한국폴리텍대학 대전캠퍼스, 2024년도 직업역량강화 우수기관 인증패 수여', author: '심광표(1000942)', dateText: '2024. 11. 21'),
  ];

  List<({
  String typeName,
  String title,
  String author,
  String dateText,
  })> get _filtered {
    // 탭 필터
    bool tabOK(String type) {
      if (_tabIndex == 1) return type == '내부공지사항';
      if (_tabIndex == 2) return type == '외부공지사항';
      return true; // 전체
    }

    // 검색어(제목/작성자)
    final q = _appliedQuery.trim().toLowerCase();
    bool queryOK(({
    String typeName,
    String title,
    String author,
    String dateText,
    }) e) {
      if (q.isEmpty) return true;
      return e.title.toLowerCase().contains(q) ||
          e.author.toLowerCase().contains(q) ||
          e.typeName.toLowerCase().contains(q);
    }

    return _items.where((e) => tabOK(e.typeName)).where(queryOK).toList();
  }

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hpad = 16.w;
    final items = _filtered;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(), // 화면 탭 시 키보드 닫힘
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 상단 탭 (고정)
            AppSegmentedTabs(
              index: _tabIndex,
              onChanged: (i) => setState(() => _tabIndex = i),
              rightTabs: const ['내부 공지사항', '외부 공지사항'],
              // 기본 라벨은 '전체'
            ),
            SizedBox(height: 16.h),

            // 검색바 (고정) + 하단 그림자
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: _scrolled ? AppShadows.stickyBar : null,
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(hpad, 0, hpad, 12.h),
                child: FilterSearchBar<String>(
                  items: _filters,
                  selected: _selectedFilter,
                  getLabel: (v) => v,
                  onSelected: (v) => setState(() => _selectedFilter = v),
                  controller: _query,
                  onSubmitted: (_) => setState(() {
                    _appliedQuery = _query.text.trim();
                  }),
                ),
              ),
            ),
            SizedBox(height: 16.h),

            // 리스트
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (n) {
                  if (n is ScrollUpdateNotification) {
                    final atTop = n.metrics.pixels <= 0;
                    if (_scrolled == atTop) setState(() => _scrolled = !atTop);
                  }
                  return false;
                },
                child: ListView.separated(
                  physics: const ClampingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: hpad),
                  itemCount: items.length + 1, // 0: 건수
                  separatorBuilder: (_, __) => SizedBox(height: 8.h),
                  itemBuilder: (_, i) {
                    if (i == 0) {
                      return Padding(
                        padding: EdgeInsets.only(left: 2.w, right: 2.w, bottom: 8.h),
                        child: CountInline(label: '전체', count: items.length),
                      );
                    }

                    final e = items[i - 1];
                    return BaseListItem(
                      // 상태/댓글/비밀 전달 안 함 → 자동 미표시
                      typeName: e.typeName,
                      title: e.title,
                      author: e.author,
                      dateText: e.dateText,
                      onTap: () => debugPrint('[NOTICE] ${e.title}'),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}