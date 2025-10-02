import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lhens_app/common/components/app_segmented_tabs.dart';
import 'package:lhens_app/common/components/buttons/fab_add_button.dart';
import 'package:lhens_app/common/components/count_inline.dart';
import 'package:lhens_app/common/components/pagination_bar.dart';
import 'package:lhens_app/common/components/report_list_item.dart';
import 'package:lhens_app/common/components/search/filter_search_bar.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_shadows.dart';

class ComplaintScreen extends ConsumerStatefulWidget {
  static String get routeName => '민원제안접수';

  const ComplaintScreen({super.key});

  @override
  ConsumerState<ComplaintScreen> createState() => _ComplaintScreenState();
}

class _ComplaintScreenState extends ConsumerState<ComplaintScreen> {
  // 상단 탭
  int _tabIndex = 0;

  // 검색
  final _query = TextEditingController();
  String _selectedFilter = '전체';
  final _filters = const ['전체', '작성자', '유형명'];
  String _appliedQuery = '';

  // 페이지네이션
  int _page = 1;
  final int _pageSize = 10;

  bool _scrolled = false;

  // 임의 데이터
  late final List<
    ({
      ReportStatus status,
      String typeName,
      String title,
      String author,
      String dateText,
      int comments,
      bool secret,
    })
  >
  _items = _mockItems(120);

  List<
    ({
      ReportStatus status,
      String typeName,
      String title,
      String author,
      String dateText,
      int comments,
      bool secret,
    })
  >
  _mockItems(int n) {
    const baseTitle =
        '민원 제목이 표시되는 영역입니다. 민원 제목이 표시되는 영역입니다. 민원 제목이 표시되는 영역입니다.';
    return List.generate(n, (i) {
      final mod = i % 6;
      final status = switch (mod) {
        0 || 3 => ReportStatus.received,
        1 || 4 => ReportStatus.processing,
        _ => ReportStatus.done,
      };
      final secret = (i % 4 == 0);
      return (
        status: status,
        typeName: '민원제안유형명',
        title: baseTitle,
        author: '조예빈(1001599)',
        dateText: '2025. 08. ${(i % 28 + 1).toString().padLeft(2, '0')}',
        comments: (i % 7),
        secret: secret,
      );
    });
  }

  List<
    ({
      ReportStatus status,
      String typeName,
      String title,
      String author,
      String dateText,
      int comments,
      bool secret,
    })
  >
  get _filtered {
    final q = _appliedQuery.toLowerCase();

    bool secretAllowed(bool isSecret) {
      if (_tabIndex == 1 && isSecret) return false; // 공개
      if (_tabIndex == 2 && !isSecret) return false; // 비공개
      return true;
    }

    bool matchesQuery(e) {
      if (q.isEmpty) return true;
      return switch (_selectedFilter) {
        '작성자' => e.author.toLowerCase().contains(q),
        '유형명' => e.typeName.toLowerCase().contains(q),
        _ =>
          e.title.toLowerCase().contains(q) ||
              e.typeName.toLowerCase().contains(q) ||
              e.author.toLowerCase().contains(q),
      };
    }

    return _items
        .where((e) => secretAllowed(e.secret))
        .where(matchesQuery)
        .toList();
  }

  int get _totalPages {
    final len = _filtered.length;
    if (len == 0) return 1;
    return ((len - 1) ~/ _pageSize) + 1;
  }

  List<
    ({
      ReportStatus status,
      String typeName,
      String title,
      String author,
      String dateText,
      int comments,
      bool secret,
    })
  >
  get _visiblePage {
    final clampedPage = _page.clamp(1, _totalPages);
    final start = (clampedPage - 1) * _pageSize;
    final end = (start + _pageSize).clamp(0, _filtered.length);
    if (start >= _filtered.length) return const [];
    return _filtered.sublist(start, end);
  }

  void _resetToFirstPage() => _page = 1;

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hpad = 16.w;
    final filtered = _filtered;
    final visible = _visiblePage;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 상단 탭 (고정)
            AppSegmentedTabs(
              index: _tabIndex,
              onChanged: (i) => setState(() {
                _tabIndex = i;
                _resetToFirstPage();
              }),
              rightTabs: const ['공개', '요청(비공개)'],
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
                  onSelected: (v) => setState(() {
                    _selectedFilter = v;
                    _resetToFirstPage();
                  }),
                  controller: _query,
                  onSubmitted: (_) => setState(() {
                    _appliedQuery = _query.text.trim();
                    _resetToFirstPage();
                  }),
                ),
              ),
            ),
            SizedBox(height: 16.h),

            // 스크롤 영역
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
                  itemCount: visible.length + 2,
                  // 0: 건수, 마지막: 페이지네이션
                  separatorBuilder: (_, __) => SizedBox(height: 8.h),
                  itemBuilder: (_, i) {
                    if (i == 0) {
                      return Padding(
                        padding: EdgeInsets.only(
                          left: 2.w,
                          right: 2.w,
                          bottom: 8.h,
                        ),
                        child: CountInline(label: '전체', count: filtered.length),
                      );
                    }
                    if (i == visible.length + 1) {
                      return Padding(
                        padding: EdgeInsets.only(top: 12.h, bottom: 72.h),
                        child: Center(
                          child: PaginationBar(
                            currentPage: _page.clamp(1, _totalPages),
                            totalPages: _totalPages,
                            onPageChanged: (p) => setState(() => _page = p),
                          ),
                        ),
                      );
                    }

                    final e = visible[i - 1];
                    return ReportListItem(
                      status: e.status,
                      typeName: e.typeName,
                      title: e.title,
                      author: e.author,
                      dateText: e.dateText,
                      commentCount: e.comments,
                      secret: e.secret,
                      onTap: () {},
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),

      // FAB
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 20.h),
        child: FabAddButton(onTap: () {}),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
