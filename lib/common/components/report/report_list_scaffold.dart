import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:lhens_app/common/components/app_segmented_tabs.dart';
import 'package:lhens_app/common/components/buttons/fab_add_button.dart';
import 'package:lhens_app/common/components/count_inline.dart';
import 'package:lhens_app/common/components/pagination_bar.dart';
import 'package:lhens_app/common/components/base_list_item.dart';
import 'package:lhens_app/common/components/empty_state.dart';
import 'package:lhens_app/common/components/search/filter_search_bar.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_shadows.dart';
import 'package:lhens_app/gen/assets.gen.dart';

import 'report_list_config.dart';
import 'base_report_item_props.dart';

class ReportListScaffold<T> extends ConsumerStatefulWidget {
  final ReportListConfig<T> config;
  final bool mineOnly;

  final Widget Function(BuildContext context, T item)? itemBuilder;

  const ReportListScaffold({
    super.key,
    required this.config,
    this.mineOnly = false,
    this.itemBuilder,
  });

  @override
  ConsumerState<ReportListScaffold<T>> createState() =>
      _ReportListScaffoldState<T>();
}

class _ReportListScaffoldState<T> extends ConsumerState<ReportListScaffold<T>> {
  final _query = TextEditingController();

  late String _selectedFilter;
  String _appliedQuery = '';
  int _tabIndex = 0;
  int _page = 1;
  static const int _pageSize = 10;
  bool _scrolled = false;

  List<T> _items = const [];

  @override
  void initState() {
    super.initState();
    assert(widget.config.filters.isNotEmpty);
    assert(
      widget.config.mapToProps != null || widget.itemBuilder != null,
      'Provide either itemBuilder or mapToProps in ReportListConfig.',
    );
    _selectedFilter = widget.config.filters.first;
    _load();
  }

  Future<void> _load() async {
    final data = await widget.config.load();
    if (!mounted) return;
    setState(() => _items = data);
  }

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  void _resetToFirstPage() => _page = 1;

  List<T> get _filtered {
    final cfg = widget.config;
    final q = _appliedQuery.toLowerCase();

    Iterable<T> base = _items;
    if (widget.mineOnly && cfg.mineOnlyPredicate != null) {
      base = base.where(cfg.mineOnlyPredicate!);
    }

    return base
        .where((e) => cfg.tabPredicate(e, _tabIndex))
        .where((e) => cfg.searchPredicate(e, _selectedFilter, q))
        .toList();
  }

  int get _totalPages {
    final len = _filtered.length;
    return len == 0 ? 1 : ((len - 1) ~/ _pageSize) + 1;
  }

  List<T> get _visiblePage {
    final clampedPage = _page.clamp(1, _totalPages);
    final start = (clampedPage - 1) * _pageSize;
    final end = (start + _pageSize).clamp(0, _filtered.length);
    if (start >= _filtered.length) return const [];
    return _filtered.sublist(start, end);
  }

  String _emptyIconPath(ReportListConfig<T> cfg) =>
      cfg.emptyIconPath ?? Assets.icons.document.path;

  Widget _emptyTop(String iconPath, String message) {
    return Column(
      children: [
        const Spacer(flex: 2),
        EmptyState(iconPath: iconPath, message: message),
        const Spacer(flex: 3),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final cfg = widget.config;
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
            // 탭
            AppSegmentedTabs(
              index: _tabIndex,
              onChanged: (i) => setState(() {
                _tabIndex = i;
                _resetToFirstPage();
              }),
              rightTabs: cfg.tabs,
            ),
            SizedBox(height: 16.h),

            // 검색바
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: _scrolled ? AppShadows.stickyBar : null,
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(hpad, 0, hpad, 12.h),
                child: FilterSearchBar<String>(
                  items: cfg.filters,
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

            // 본문
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (n) {
                  if (n is ScrollUpdateNotification) {
                    final atTop = n.metrics.pixels <= 0;
                    if (_scrolled == atTop) {
                      setState(() => _scrolled = !atTop);
                    }
                  }
                  return false;
                },
                child: noData
                    ? _emptyTop(
                        _emptyIconPath(cfg),
                        cfg.emptyMessage(_tabIndex, mineOnly: widget.mineOnly),
                      )
                    : searchNoResult
                    ? _emptyTop(Assets.icons.search.path, '검색어와 일치하는 결과가 없습니다.')
                    : tabNoResult
                    ? _emptyTop(
                        _emptyIconPath(cfg),
                        cfg.emptyMessage(_tabIndex, mineOnly: widget.mineOnly),
                      )
                    : ListView.separated(
                        physics: const ClampingScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: hpad),
                        itemCount: visible.length + 2,
                        separatorBuilder: (_, __) => SizedBox(height: 8.h),
                        itemBuilder: (_, i) {
                          if (i == 0) {
                            return Padding(
                              padding: EdgeInsets.only(
                                left: 2.w,
                                right: 2.w,
                                bottom: 8.h,
                              ),
                              child: CountInline(
                                label: '전체',
                                count: filtered.length,
                              ),
                            );
                          }
                          if (i == visible.length + 1) {
                            return Padding(
                              padding: EdgeInsets.only(top: 12.h, bottom: 72.h),
                              child: Center(
                                child: PaginationBar(
                                  currentPage: _page.clamp(1, _totalPages),
                                  totalPages: _totalPages,
                                  onPageChanged: (p) =>
                                      setState(() => _page = p),
                                ),
                              ),
                            );
                          }

                          final item = visible[i - 1];

                          // 커스텀 빌더 우선
                          if (widget.itemBuilder != null) {
                            return widget.itemBuilder!(context, item);
                          }

                          // 기본 BaseListItem
                          final ReportListItemProps props = cfg.mapToProps!(
                            item,
                          );
                          final routeName =
                              widget.mineOnly && cfg.myDetailRouteName != null
                              ? cfg.myDetailRouteName!
                              : cfg.detailRouteName;

                          return BaseListItem(
                            status: props.status,
                            typeName: props.typeName,
                            title: props.title,
                            author: props.author,
                            dateText: props.dateText,
                            commentCount: props.commentCount,
                            secret: props.secret,
                            onTap: () {
                              if (cfg.onItemTap != null) {
                                cfg.onItemTap!(context, item);
                              } else {
                                context.pushNamed(routeName);
                              }
                            },
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),

      // FAB
      floatingActionButton: cfg.showFab
          ? Padding(
              padding: EdgeInsets.only(bottom: 20.h),
              child: FabAddButton(
                onTap: () => context.pushNamed(cfg.formRouteName),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
