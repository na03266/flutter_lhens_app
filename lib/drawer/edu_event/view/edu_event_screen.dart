import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:lhens_app/common/components/app_segmented_tabs.dart';
import 'package:lhens_app/common/components/count_inline.dart';
import 'package:lhens_app/common/components/empty_state.dart';
import 'package:lhens_app/common/components/pagination_bar.dart';
import 'package:lhens_app/common/components/search/filter_search_bar.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_shadows.dart';
import 'package:lhens_app/gen/assets.gen.dart';

import '../component/edu_event_list_item.dart';
import 'edu_event_detail_screen.dart';

class EduEventScreen extends ConsumerStatefulWidget {
  static String get routeName => '교육행사정보';

  final bool mineOnly; // 확장성(필요 시), 현재는 사용 안 함

  const EduEventScreen({super.key, this.mineOnly = false});

  @override
  ConsumerState<EduEventScreen> createState() => _EduEventScreenState();
}

class _EduEventScreenState extends ConsumerState<EduEventScreen> {
  // 탭: 전체 / 교육 / 행사
  int _tabIndex = 0;

  // 검색
  final _query = TextEditingController();
  String _appliedQuery = '';
  final _filters = const ['전체'];
  String _selectedFilter = '전체';

  // 페이지네이션
  int _page = 1;
  static const int _pageSize = 10;

  bool _scrolled = false;

  // ===== Mock 데이터 =====
  late final List<({
    String type, // '교육정보' | '행사정보'
    String title,
    String dept,
    String period,
  })> _items = [
    (
      type: '교육정보',
      title: '2025 안전보건 규정 변경 및 실무교육',
      dept: '기획조정실 안전보건팀',
      period: '2025. 01. 15 ~ 2025. 01. 16',
    ),
    (
      type: '교육정보',
      title: '2025 신규 사업 기획 전략과 프로젝트 관리 프로세스 개선을 위한 실무 워크숍',
      dept: '기획조정실 사업기획팀',
      period: '2025. 01. 15 ~ 2025. 01. 16',
    ),
    (
      type: '행사정보',
      title: '2025 LH E&S 전사 체육대회 및 친목 행사',
      dept: '경영지원실 인사노무팀',
      period: '2025. 01. 15 ~ 2025. 01. 16',
    ),
    (
      type: '교육정보',
      title: '공공현장 안전·환경 관리 역량 강화를 위한 사례 기반 워크숍 및 실습 과정',
      dept: '사업운영본부 경기북부지사',
      period: '2025. 01. 15 ~ 2025. 01. 16',
    ),
    (
      type: '교육정보',
      title: '재무 보고서 작성 및 회계 처리 실습 과정',
      dept: '경영지원실 재무회계팀',
      period: '2025. 01. 15 ~ 2025. 01. 16',
    ),
  ];

  // 필터링 + 검색
  List<({String type, String title, String dept, String period})> get _filtered {
    bool tabOK(String type) {
      if (_tabIndex == 1) return type == '교육정보';
      if (_tabIndex == 2) return type == '행사정보';
      return true;
    }

    final q = _appliedQuery.trim().toLowerCase();
    bool queryOK(e) {
      if (q.isEmpty) return true;
      return e.title.toLowerCase().contains(q) ||
          e.dept.toLowerCase().contains(q) ||
          e.type.toLowerCase().contains(q);
    }

    return _items.where((e) => tabOK(e.type)).where(queryOK).toList();
  }

  int get _totalPages {
    final len = _filtered.length;
    return len == 0 ? 1 : ((len - 1) ~/ _pageSize) + 1;
  }

  List<({String type, String title, String dept, String period})> get _visiblePage {
    final cur = _page.clamp(1, _totalPages);
    final start = (cur - 1) * _pageSize;
    final end = (start + _pageSize).clamp(0, _filtered.length);
    if (start >= _filtered.length) return const [];
    return _filtered.sublist(start, end);
  }

  void _resetToFirstPage() => _page = 1;

  String _emptyMessage() {
    if (_tabIndex == 1) return '등록된 교육 정보가 없습니다.';
    if (_tabIndex == 2) return '등록된 행사 정보가 없습니다.';
    return '등록된 교육행사 정보가 없습니다.';
  }

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

    final noData = _items.isEmpty;
    final hasQuery = _appliedQuery.trim().isNotEmpty;
    final searchNoResult = !noData && hasQuery && filtered.isEmpty;
    final tabNoResult = !noData && !hasQuery && filtered.isEmpty;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 탭: 전체 / 교육 / 행사
            AppSegmentedTabs(
              index: _tabIndex,
              onChanged: (i) => setState(() {
                _tabIndex = i;
                _resetToFirstPage();
              }),
              rightTabs: const ['교육', '행사'],
            ),
            SizedBox(height: 16.h),

            // 검색바 + 스티키 그림자
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

            // 리스트 영역
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (n) {
                  if (n is ScrollUpdateNotification) {
                    final atTop = n.metrics.pixels <= 0;
                    if (_scrolled == atTop) setState(() => _scrolled = !atTop);
                  }
                  return false;
                },
                child: noData
                    ? _emptyTop(Assets.icons.document.path, '등록된 교육행사 정보가 없습니다.')
                    : searchNoResult
                        ? _emptyTop(Assets.icons.search.path, '검색어와 일치하는 결과가 없습니다.')
                        : tabNoResult
                            ? _emptyTop(Assets.icons.document.path, _emptyMessage())
                            : ListView.separated(
                                physics: const ClampingScrollPhysics(),
                                padding: EdgeInsets.symmetric(horizontal: hpad),
                                itemCount: visible.length + 2, // 건수 + 페이지네이션
                                separatorBuilder: (_, __) => SizedBox(height: 8.h),
                                itemBuilder: (_, i) {
                                  if (i == 0) {
                                    return Padding(
                                      padding: EdgeInsets.only(left: 2.w, right: 2.w, bottom: 8.h),
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
                                  return EduEventListItem(
                                    typeName: e.type,
                                    title: e.title,
                                    targetDept: e.dept,
                                    periodText: e.period,
                                    onTap: () => context.pushNamed(EduEventDetailScreen.routeName),
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

  Widget _emptyTop(String iconPath, String message) {
    return Column(
      children: [
        const Spacer(flex: 2),
        EmptyState(iconPath: iconPath, message: message),
        const Spacer(flex: 3),
      ],
    );
  }
}
